function sds_=sds_open(file)
%SDS_OPEN   open an existing sds file and initialize the sds structure
%
%                        SDS file format
%
%   *** SDS is one of the file formats of the SFC collection ***
%
% The SDS (Simple DS) format is intended for storing one or more data
% streams, with the same time beginning and the same sampling time.
% 
% The format is the following :
%
%  prot     - 4 bytes int32  (1-4)         protocol (integer; now 1)
%  nch      - 4 bytes int32  (5-8)         number of channels (N; integer)
%  len      - 8 bytes int64  (9-16)        length of the stream (0 if it is not known)
%  t0       - 8 bytes double (17-24)       beginning time (double)
%  dt       - 8 bytes double (25-32)       sampling time (double)
%  capt     - 128 bytes string             caption
%  ch()     - N*128 bytes strings          names and captions for the channels
%  filme    - 128 bytes string             original name of the file
%  filmaster- 128 bytes string             master file
%  filspre  - 128 bytes string             serial preceding file
%  filspost - 128 bytes string             serial subsequent file
%  filppre  - 128 bytes string             parallel preceding file
%  filppost - 128 bytes string             parallel subsequent file
%  inidat   - 4 bytes int32                pointer to the beginning (>= 932+N*128)
%  user     - (free)                       user header
%  data     - N*4*len bytes float          the data (l for each channel; float)
%
% To access the user header, fseek(fid,932+N*128,'bof')
%
%                       sds_ structure
%
%   sds_.file      file name (with path)
%   sds_.pnam      file path
%   sds_.fid       fid
%   sds_.prot      protocol
%   sds_.t0        beginning time
%   sds_.dt        sampling time
%   sds_.capt      caption
%   sds_.nch       number of channels
%   sds_.ch(nch)   channel captions
%   sds_.hlen      user header length (bytes)
%   sds_.len       length of a stream (the total number of data is len*nch)
%   sds_.point0    pointer to beginning of data
%   sds_.point     pointer for next data
%   sds_.eof       end of file (1; for chained files, 2 -> end of chain)
%   sds_filme      original name of the file
%   sds_filmaster  master file
%   sds_filspre    serial preceding file
%   sds_filspost   serial subsequent file
%   sds_filppre    parallel preceding file
%   sds_filppost   parallel subsequent file

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_.file=file;
fid=fopen(file,'r');
sds_.fid=fid;
[file,pnam]=path_from_file(file);
sds_.pnam=pnam;

sds_.prot=fread(fid,1,'int32');
sds_.nch=fread(fid,1,'int32');

sds_.len=fread(fid,1,'int64');

sds_.t0=fread(fid,1,'double');
sds_.dt=fread(fid,1,'double');

%sds_.capt=fscanf(fid,'%128s');
capt=fread(fid,128,'char');
sds_.capt=blank_trim(char(capt'));

for i = 1:sds_.nch
    %sds_.ch{i}=fscanf(fid,'%128s');
    ch=fread(fid,128,'char');
    sds_.ch{i}=blank_trim(char(ch'));
end

fil=fread(fid,128,'char');
sds_.filme=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sds_.filmaster=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sds_.filspre=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sds_.filspost=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sds_.filppre=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sds_.filppost=blank_trim(char(fil'));

sds_.point0=fread(fid,1,'int32');
sds_.hlen=sds_.point0-(932+128*sds_.nch);
fseek(fid,sds_.point0,'bof');

%sds_.point=ftell(fid);
sds_.point=sds_.point0;
sds_.eof=0;

if sds_.len == 0
    len=0;
    l=1000;
    while l == 1000
        [a,l]=fread(fid,1000,'float');
        len=len+l;
    end
    sds_.len=len/sds_.nch;
    fseek(fid,sds_.point,'bof');
end