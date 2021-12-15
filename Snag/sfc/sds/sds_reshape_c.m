function sds_reshape_c %(listin,maxndat,folderin,folderout)
%SDS_RESHAPE  from a set of sds files, recreates a new set with different maxlength
%
%   listin    list of input file (in a text file, typically in the input folder)
%   maxndat   maximum number of data per channel
%   folderin, folderout  input, output folder (optional - without final slash)
%
% New files are also concatenated.
% All the files should have the same number of channels and same dt.
% Don't use same folder for input and output files !

% Version 2.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listin='lista.txt';
maxndat=3600*4000*10;
if ~exist('folderin')
    folderin=selfolder_c('Input files folder');
end

if ~exist('folderout')
    folderout=folderin;
    while strcmp(folderin,folderout)
        folderout=selfolder_c('Output files folder',folderin);
        if strcmp(folderin,folderout)
            disp('Don''t use same folder for input and output files !')
        end
    end 
end

prefilout='#NOFILE';

fid=fopen(listin,'r');
if fid < 0
    disp([listin ' file could not be opened'])
    return;
end
nfiles=0;

while (feof(fid) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fid,'%s',1);
    str=sprintf('  %s ',file{nfiles});
    disp(str);
end

nfiles=nfiles-1

ndatout=0;

for i = 1:nfiles
    disp([' --> in ' file{i}]);
    sds1=sds_open_c([folderin filesep file{i}]);
    t1=sds1.t0;
    if t1 > 100000
        disp(' *** time in gps - > corrected');
        t1=gps2mjd_c(t1);
        sds1.t0=t1;
    end
    if i == 1
        sds0=sds1;
        sds0.len=0;
        nch=sds0.nch;
        dt=sds0.dt;
        rest=maxndat*nch;
        t2=t1;
        fileout=new_file(file{i},t2);
        sds2=sds_openw_c([folderout filesep fileout],sds0);
    else
        if sds1.nch ~= nch
            disp([' *** ERROR ! different number of channels in ' file{i}]);
            return
        end
        if sds1.dt ~= dt
            disp([' *** ERROR ! different sampling time in ' file{i}]);
            return
        end
        if abs(t1-t1next) > dt/86400
            %(t1-t1next)*86400/dt
            fileout1=fileout;
            t2=t1;
            fileout=new_file(file{i},t2);
            close_sdsfile(sds2.fid,prefilout,fileout,ndatout/nch);
            prefilout=fileout1;
            sds0.t0=t2;
            sds2=sds_openw_c([folderout filesep fileout],sds0);
            rest=maxndat*nch;
            ndatout=0;
        end
    end
    ndataread=0;
    outdata=1;
    while outdata > 0
        [y,outdata]=fread(sds1.fid,1000*nch,'float32');
        if outdata > 0
            ndataread=ndataread+outdata;
            outdata1=min(outdata,rest);
            ndatout=ndatout+outdata1;
            fwrite(sds2.fid,y(1:outdata1),'float32');
            rest=rest-outdata1;
            if rest <= 0
                fileout1=fileout;
                t2=t2+maxndat*dt/86400;
                fileout=new_file(file{i},t2);
                close_sdsfile(sds2.fid,prefilout,fileout,ndatout/nch);
                prefilout=fileout1;
                sds0.t0=t2;
                sds2=sds_openw_c([folderout filesep fileout],sds0);
                rest=maxndat*nch;
                outdata1=outdata-outdata1;
                
                ndatout=outdata1;
                fwrite(sds2.fid,y(1:outdata1*nch));
%                 t0=t0+outdata1*(sds2.dt/86400);
                rest=rest-outdata1;
            end
        end
    end
    
    t1next=t1+(dt/86400)*ndataread/nch;
    fclose(sds1.fid);
end

close_sdsfile(sds2.fid,prefilout,'#NOFILE',ndatout/nch);


function fileout=new_file(filein,t2)

k=findstr(filein,'_');
fileout=filein;
str=mjd2_d_t_c(t2);
kend=length(k);
fileout(k(kend-2):k(kend))=str;
disp([' <-- out ' fileout]);


function close_sdsfile(fid,prefilout,postfilout,n)

point1=24;
fseek(fid,point1,'bof');
point1=48+128+128*2;
fwrite(fid,n,'int64');
fseek(fid,point1,'bof');
fprintf(fid,'%128s',prefilout);
fprintf(fid,'%128s',postfilout);

fclose(fid);


function mjd=gps2mjd_c(tgps)
%GPS2MJD   conversion from gps time to mjd
%
%     t=gps2mjd(tgps)
%
%     tgps   gps time (in seconds)
%     mjd    modified julian date (days)
%
%  GPS time is 0 at 6-Jan-1980 0:00:00 and it is linked to TAI.
%  It is offset from UTC for the insertion of the leap seconds.
%

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

t0=44244;
mjd=tgps/86400+t0;
mjd=mjd-(leap_seconds_c(mjd)-19)/86400;


function folder=selfolder_c(dialog_title,startfolder)
%SELFOLDER  selects a folder (directory) 
%
%        folder=selfile(dialog_title,startfolder)
%
%   dialog_title, startfolder   

% Version 1.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('dialog_title')
    dialog_title='Folder selection';
end
if ~exist('startfolder')
    startfolder=' ';
end
cddir=['cd ' startfolder];
eval(cddir);

folder=uigetdir(startfolder,dialog_title);



function sds_=sds_open_c(file,pers)
%SDS_OPEN   opens an existing sds file and initialize the sds structure;
%           if pers (periods) is specified, opens the first file with data in
%           one of the defined ranges; in this case the operation is logged.
%
%    file        file to open
%    pers        (n,2) array containing the start and stop time of the n periods.
%                It is omitted or 0 if there are no selection periods. If pers is
%                in action, the operation is logged on sds.log .
%
%    sds_        sds structure
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
%  label    - 8 bytes string (1-8)         #SFC#SDS
%
% First 944 bytes : see the sfc_open function.
%
%  ch()     - N*128 bytes strings          names and captions for the channels
%  user     - (free)                       user header
%  data     - N*4*len bytes float          the data (l for each channel; float)
%
% To access the user header, fseek(fid,944+N*128,'bof')
%
% The sds_ structure derives from the sfc_ structure.
% The added or modified members are:
%
%   sds_.ch(nch)   channel captions
%   sds_.len       length of a stream (the total number of data is len*nch)
%   sds_.point     pointer for next data
%
% A particular type of sds file is the t-type in which the first channel is
% a time abscissa (normally in days).It is recognized by the channel
% caption that begins with "timing channel".

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

noper=1; % no observation periods considered 
if exist('pers')
    if length(pers) > 1
        noper=0; % observation periods considered 
        fidlog=fopen('sds.log','w');
    end
end

ck0=0;

while ck0 == 0
    sds_=sfc_open_c(file);
    fid=sds_.fid;
    ck0=5;
	if fid == -1
        if noper == 0
            fprintf(fidlog,'Non-existing file %s  \r\n',file);
            fclose(fidlog);
        end
        return
	end
	if sds_.len == 0
        fseek(fid,0,'eof');
        len=ftell(fid);
%         len=0;
%         l=1000;
%         while l == 1000
%             [a,l]=fread(fid,1000,'float');
%             len=len+l;
%         end
         sds_.len=(len-sds_.point0)/(sds_.nch*4);
        fseek(fid,sds_.point0-sds_.nch*128,'bof');
	end
    for i = 1:sds_.nch
        ch=fread(fid,128,'char');
        sds_.ch{i}=blank_trim_c(char(ch'));
	end
	
	fseek(fid,sds_.point0,'bof');
	
	sds_.point=sds_.point0;
    if noper == 0
        fprintf(fidlog,'Open %s at %s \r\n',sds_.file,datestr(now));
        tim0=sds_.t0;
        tim1=tim0+sds_.len*sds_.dt/86400;
        ck0=sds_check_time_c(tim0,tim1,pers); %,tim0,tim1,pers
        if ck0 == 0
            fclose(sds_.fid);
            file=[sds_.pnam sds_.filspost];
            if strcmp(sds_.filspost,'#NOFILE')
                sds_.eof=2;
                str=sprintf(' --------> End of files');
                disp(str);
                fprintf(fidlog,' End of files at %s ',datestr(now));
            end
        end
    end
end

if noper == 0
    fclose(fidlog);
end

sds_.eof=0;



function sds_=sds_openw_c(file,sds_)
%SDS_OPENW  open an sds file for writing
%
%   file      file to open
%   sds_      sds structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_.file=file;

sds_.label='#SFC#SDS';
sds_.prot=1;
sds_.coding=0;

sds_=sfc_openw_c(file,sds_);

for i = 1:sds_.nch
    fprintf(sds_.fid,'%128s',sds_.ch{i});%sds_.ch{i}
end



function s=mjd2_d_t_c(mjd)
%MJD2_d_t   converts a modified julian date to DDDDDDDD_TTTTTT

v=datevec(mjd+678942);
v(6)=floor(v(6));
s=sprintf('_%04d%02d%02d_%02d%02d%02d_',v);



function nls=leap_seconds_c(mjd)
%LEAP_SECONDS  number of leap seconds at a certain mjd
%
%                             Leap seconds
%         (*** TO BE UPGRADED EVERY SIX MONTHS - prob next 2004)
%
%  1972 JAN  1 =JD 2441317.5  TAI-UTC=  10.0       S + (MJD - 41317.) X 0.0      S
%  1972 JUL  1 =JD 2441499.5  TAI-UTC=  11.0       S + (MJD - 41317.) X 0.0      S
%  1973 JAN  1 =JD 2441683.5  TAI-UTC=  12.0       S + (MJD - 41317.) X 0.0      S
%  1974 JAN  1 =JD 2442048.5  TAI-UTC=  13.0       S + (MJD - 41317.) X 0.0      S
%  1975 JAN  1 =JD 2442413.5  TAI-UTC=  14.0       S + (MJD - 41317.) X 0.0      S
%  1976 JAN  1 =JD 2442778.5  TAI-UTC=  15.0       S + (MJD - 41317.) X 0.0      S
%  1977 JAN  1 =JD 2443144.5  TAI-UTC=  16.0       S + (MJD - 41317.) X 0.0      S
%  1978 JAN  1 =JD 2443509.5  TAI-UTC=  17.0       S + (MJD - 41317.) X 0.0      S
%  1979 JAN  1 =JD 2443874.5  TAI-UTC=  18.0       S + (MJD - 41317.) X 0.0      S
%  1980 JAN  1 =JD 2444239.5  TAI-UTC=  19.0       S + (MJD - 41317.) X 0.0      S
%  1981 JUL  1 =JD 2444786.5  TAI-UTC=  20.0       S + (MJD - 41317.) X 0.0      S
%  1982 JUL  1 =JD 2445151.5  TAI-UTC=  21.0       S + (MJD - 41317.) X 0.0      S
%  1983 JUL  1 =JD 2445516.5  TAI-UTC=  22.0       S + (MJD - 41317.) X 0.0      S
%  1985 JUL  1 =JD 2446247.5  TAI-UTC=  23.0       S + (MJD - 41317.) X 0.0      S
%  1988 JAN  1 =JD 2447161.5  TAI-UTC=  24.0       S + (MJD - 41317.) X 0.0      S
%  1990 JAN  1 =JD 2447892.5  TAI-UTC=  25.0       S + (MJD - 41317.) X 0.0      S
%  1991 JAN  1 =JD 2448257.5  TAI-UTC=  26.0       S + (MJD - 41317.) X 0.0      S
%  1992 JUL  1 =JD 2448804.5  TAI-UTC=  27.0       S + (MJD - 41317.) X 0.0      S
%  1993 JUL  1 =JD 2449169.5  TAI-UTC=  28.0       S + (MJD - 41317.) X 0.0      S
%  1994 JUL  1 =JD 2449534.5  TAI-UTC=  29.0       S + (MJD - 41317.) X 0.0      S
%  1996 JAN  1 =JD 2450083.5  TAI-UTC=  30.0       S + (MJD - 41317.) X 0.0      S
%  1997 JUL  1 =JD 2450630.5  TAI-UTC=  31.0       S + (MJD - 41317.) X 0.0      S
%  1999 JAN  1 =JD 2451179.5  TAI-UTC=  32.0       S + (MJD - 41317.) X 0.0      S
%  2006 JAN  1 =JD 2453736.5  TAI-UTC=  33.0       S + (MJD - 41317.) X 0.0      S

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

leaptimes=zeros(30,1);

leaptimes(1)=41317;
leaptimes(2)=41499;
leaptimes(3)=41683;
leaptimes(4)=42048;
leaptimes(5)=42413;
leaptimes(6)=42778;
leaptimes(7)=43144;
leaptimes(8)=43509;
leaptimes(9)=43874;

leaptimes(10)=44786;
leaptimes(11)=45151;
leaptimes(12)=45516;
leaptimes(13)=46247;
leaptimes(14)=47161;
leaptimes(15)=47892;
leaptimes(16)=48257;
leaptimes(17)=48804;
leaptimes(18)=49169;
leaptimes(19)=49534;
leaptimes(20)=50083;
leaptimes(21)=50630;
leaptimes(22)=51179;
leaptimes(23)=53736;

nls=33; % max leap TO BE UPDATE FOR EACH NEW LEAP SECOND !

for i = (nls-10):-1:1
   if mjd > leaptimes(i)
       break
   end
   nls=nls-1;
end


function sfc_=sfc_open_c(file)
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
[file,pnam]=path_from_file_c(file);
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
sfc_.len=fread(fid,1,'int64');

sfc_.t0=fread(fid,1,'double');
sfc_.dt=fread(fid,1,'double');

capt=fread(fid,128,'char');
sfc_.capt=blank_trim_c(char(capt'));

fil=fread(fid,128,'char');
sfc_.filme=blank_trim_c(char(fil'));
fil=fread(fid,128,'char');
sfc_.filmaster=blank_trim_c(char(fil'));
fil=fread(fid,128,'char');
sfc_.filspre=blank_trim_c(char(fil'));
fil=fread(fid,128,'char');
sfc_.filspost=blank_trim_c(char(fil'));
fil=fread(fid,128,'char');
sfc_.filppre=blank_trim_c(char(fil'));
fil=fread(fid,128,'char');
sfc_.filppost=blank_trim_c(char(fil'));

sfc_.hlen=(944+128*sfc_.nch);


function [ck,dtim,kper]=sds_check_time_c(tim0,tim1,pers)
%SDS_CHECK_TIME  checks the bounds of a time interval
%
%      tim0,tim1  interval bounds
%         pers    (n,2) array containing the start and stop time of the n allowed periods
%
%          ck     = 0 -> completely external 
%                 = 1 -> beginning internal, end external
%                 = 2 -> beginning external, end internal
%                 = 3 -> completely internal
%                 = 4 -> embedding one or more periods 
%                        (beginning and end external, but enbedding)
%         dtim    time inside
%         kper    number of chosen period

[n,dum]=size(pers);
if dum < 2
    error('error in the pers array');
end
i0=0;
i1=0;
kper=0;
dtim=0;

for i = 1:n
    t0=pers(i,1);
    t1=pers(i,2);
    if tim0 >= t0 & tim0 <= t1
        i0=1;
        kper=i;
        t0=tim0;
        if tim1 >= pers(i,1) & tim1 <= pers(i,2)
            i1=1;
            dtim=tim1-tim0;
        else
            dtim=t1-tim0;
        end
    end
end

if kper == 0
    for i = 1:n
        t0=pers(i,1);
        t1=pers(i,2);
        if tim1 >= t0 & tim1 <= t1
            i1=1;
            kper=i
            dtim=tim1-t0;
        end
	end
end

ck=i0+2*i1;

if ck == 0
    dtim=0;
    for i = 1:n
        t0=pers(i,1);
        t1=pers(i,2);
        if tim0 <= t0 & tim1 >= t1
            ck=4;
            kper=i;
            dtim=dtim+t1-t0;
        end
	end
end



function out=blank_trim_c(in)
%BLANK_TRIM  trims blanks and nulls from both sides of a string

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

din=double(in);
i1=0;c1=0;
i2=0;

for i = 1:length(din)
    if din(i) ~= 0 & din(i) ~= 32
        c1=1;
        i2=i;
    end
    if c1 == 0
        i1=i;
    end
end

out=char(din(i1+1:i2));



function [file,pnam]=path_from_file_c(file)
%PATH_FROM_FILE  extracts the path and the filename from a path+filename string
%

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nfile=double(file);
lastsl=0;
len=length(file);

for i = 1:len
    if nfile(i) == 47 | nfile(i) == 92
        lastsl=i;
    end
end

pnam=char(file(1:lastsl));
file=char(file(lastsl+1:len));



function sfc_=sfc_openw_c(file,sfc_)
%SFC_OPENW  open an sds file for writing
%
%   file      file to open
%   sfc_      sfc structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sfc_.acc=0;
sfc_.file=file;

fid=fopen(file,'w');
sfc_.fid=fid;
[file,pnam]=path_from_file_c(file);
sfc_.pnam=pnam;

fprintf(fid,'%8s',sfc_.label);
fwrite(fid,sfc_.prot,'int32');
fwrite(fid,sfc_.coding,'uint32');

fwrite(fid,sfc_.nch,'int32');
fwrite(fid,(944+128*sfc_.nch),'int32');
fwrite(fid,sfc_.len,'int64');

fwrite(fid,sfc_.t0,'double');
fwrite(fid,sfc_.dt,'double');

fprintf(fid,'%128s',sfc_.capt);

fprintf(fid,'%128s',file);
nofile='#NOFILE';
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);

