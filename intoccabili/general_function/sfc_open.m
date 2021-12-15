function sfc_=sfc_open(file)
%SFC_OPEN   open an existing sfc file and initialize the sfc structure
%
%                        SFC file format
%
%   *** SDS and SBL are some of the file formats of the SFC collection ***
%
% The format is the following :
%
%  label    - 8 bytes string (1-8)         type label (e.g. #SFC#SDS)
%  prot     - 4 bytes int32  (9-12)        protocol (integer; now 1)
%  coding   - 4 bytes int32  (13-16)       machine and data coding (normally 0)
%
%  nch      - 4 bytes int32  (17-20)       number of channels (N; integer)
%  inidat   - 4 bytes int32  (21-24)       pointer to the beginning of data (>= 944+N*128)
%  len      - 8 bytes int64  (25-32)       number of blocks (sbl) or data per channel (sds)
%                                            (0 if it is not known)
%
%  t0       - 8 bytes double (33-40)       beginning time (double); may be not meaningful
%  dt       - 8 bytes double (41-48)       sampling time (double); may be not meaningful
%
%  capt     - 128 bytes string             caption
%  filme    - 128 bytes string             original name of the file
%  filmaster- 128 bytes string             master file
%  filspre  - 128 bytes string             serial preceding file
%  filspost - 128 bytes string             serial subsequent file
%  filppre  - 128 bytes string             parallel preceding file
%  filppost - 128 bytes string             parallel subsequent file
%
%    Here ends the general part, read by this function; then:
%
%  ch()     - N*128 bytes                  depends on the sfc type
%                           *** The channels can be sampled data, single parameters,
%                               sets of parameters, matrices, strings, etc.
%
%  user     - (free)                       user file header
%                           *** The user header length is (inidat - 944+N*128) bytes
%                           
%  data     - ...                          the data (depends on the sfc type)
%                           *** The data are in N parallel streams (sds) or divided
%                               in blocks (sbl)
%
% To access the user header, fseek(fid,944+N*128,'bof')
%
%                       sfc_ structure
%
%   sfc_.file      file name (with path)
%   sfc_.pnam      file path
%   sfc_.fid       fid
%   sfc_.label     label (e.g. #SFC#SDS)
%   sfc_.prot      protocol
%   sfc_.coding    machine and data coding
%   sfc_.t0        beginning time
%   sfc_.dt        sampling time
%   sfc_.capt      caption
%   sfc_.nch       number of channels
%   sfc_.ch(nch)   channel structures (depends on type)
%   sfc_.hlen      non-user header length (bytes)
%   sfc_.len       length of a stream (the total number of data is len*nch)
%                  or number of blocks
%   sfc_.point0    pointer to beginning of data
%   sfc_.eof       end of file (1; for chained files, 2 -> end of chain, 3 -> error,
%                   -1 -> end chosen period)
%   sfc_.acc       access number; 0 at beginning, incremented by user if 
%                   not accessed in standard ways
%   sfc_filme      original name of the file
%   sfc_filmaster  master file
%   sfc_filspre    serial preceding file
%   sfc_filspost   serial subsequent file
%   sfc_filppre    parallel preceding file
%   sfc_filppost   parallel subsequent file

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sfc_.acc=0;
sfc_.file=file;
fid=fopen(file,'r');
sfc_.fid=fid;
[file,pnam]=path_from_file(file);
sfc_.pnam=pnam;
if fid == -1
    disp([file ' non-existent file !'])
    sfc_.eof=3;
    return
end

sfc_.label=fread(fid,8,'char');
if strcmp(char(sfc_.label(1:5)'),'#SFC#')~=1
    error([file ' is not an SFC file !']);
    return
end
        
sfc_.prot=fread(fid,1,'int32');
sfc_.coding=fread(fid,1,'uint32');

sfc_.nch=fread(fid,1,'int32');
sfc_.point0=fread(fid,1,'int32');
sfc_.userlen=sfc_.point0-(944+128*sfc_.nch);
if sfc_.userlen ~= 0
    disp(sprintf(' User header length %d',sfc_.userlen))
end
sfc_.len=fread(fid,1,'int64');

sfc_.t0=fread(fid,1,'double');
sfc_.dt=fread(fid,1,'double');

capt=fread(fid,128,'char');
sfc_.capt=blank_trim(char(capt'));

fil=fread(fid,128,'char');
sfc_.filme=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sfc_.filmaster=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sfc_.filspre=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sfc_.filspost=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sfc_.filppre=blank_trim(char(fil'));
fil=fread(fid,128,'char');
sfc_.filppost=blank_trim(char(fil'));

sfc_.hlen=(944+128*sfc_.nch);

