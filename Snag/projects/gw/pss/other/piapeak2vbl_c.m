function piapeak2vbl_c
%
%   piapeak2vbl(2000/2^21,2^22)
%
% Pia-Peak format:
%
%     Header
% nfft      int32
%
%   Block header
% mjd       double
% nmax      int32
% velx      double
% vely      double
% velz      double
%
%     Data (nmax times)
% bin       int32
% ratio     float
% xamed     float (mean of H)

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


prompt={'Frequency bin ? (def 4000/2^22)'...
     'FFT length (samples) ? (def 2^22)'...
     'Separator ? (def \)'};
defarg={'2000/2^21' '2^22' filesep};

answ=inputdlg(prompt,'Input data',1,defarg);

dfr=eval(answ{1});
lfft=eval(answ{2});
dirsep=answ{3};

piafile=selfile_c('  ','piafile ?');
piafid=fopen(piafile);
[pathstr, name, ext, versn] = fileparts(piafile);
filout=[pathstr dirsep name '.vbl'];

inix=0;
vbl_.nch=3;
vbl_.capt=['from ' piafile ' Pia file'];

vbl_.ch(1).capt='DETV detector velocity';
vbl_.ch(2).capt='PEAKBIN peak frequency bin';
vbl_.ch(3).capt='PEAKAMP peak amplitude';

vbl_.ch(1).type=6;
vbl_.ch(2).type=3;
vbl_.ch(2).dx=dfr;
vbl_.ch(2).lenx=lfft/2;
vbl_.ch(3).type=4;

ch.dx=dfr;
ch.dy=0;
ch.inix=0;
ch.iniy=0;
ch.lenx=0;
ch.leny=0;
ch.type=0;
ch.point=0;

nfft=fread(piafid,1,'int32');
vbl_.len=nfft;

vbl_=vbl_openw_c(filout,vbl_);

blpoint=zeros(1,nfft);
blp=vbl_.point0;

for i = 1:nfft
    blpoint(i)=blp;
    mjd=fread(piafid,1,'double');
    nmax=fread(piafid,1,'int32');
    blocklength=32+60*3+3*8+nmax*(4+4);
    nextblock=blp+blocklength;
    if i == nfft
        nextblock=0;
    end
    vbl_headblw_c(vbl_.fid,i,mjd,nextblock)
    v=fread(piafid,3,'double');
    a=zeros(1,nmax);
    b=a;
    for j = 1:nmax
        b(j)=fread(piafid,1,'int32');
        a(j)=fread(piafid,1,'float');
        x=fread(piafid,1,'float');
    end
    
    chp=ftell(vbl_.fid);
    chpoint=chp+60+3*8;
    ch.numb=1;
    ch.lenx=length(v);
    ch.inix=0;
    ch.type=6;
    vbl_headchw_c(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,v,'double');
    
    chpoint=chpoint+60+nmax*4;
    ch.numb=2;
    ch.lenx=length(b);
    ch.inix=inix;
    ch.type=3;
    vbl_headchw_c(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,b,'int32');
    chpoint=0;
    ch.numb=3;
    ch.lenx=length(a);
    ch.inix=0;
    ch.type=4;
    vbl_headchw_c(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,a,'float32');
    
    blp=blp+blocklength;
end

vbl_closew_c(vbl_,blpoint,nfft);


function [f,pnam,fnam]=selfile_c(direc,question)
%SELFILE  selects a file in a directory
%
%        f=selfile(direc)
%
%   f        file with path
%   pnam     path
%   direc    the directory

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('question','var')
    question='File Selection';
end
    
cddir=['cd ' direc];
eval(cddir);

[fnam,pnam]=uigetfile('*.*',question);

f=strcat(pnam,fnam);



function vbl_=vbl_openw_c(file,vbl_)
%VBL_OPENW  open an vbl file for writing
%
%   file      file to open
%   vbl_      vbl structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

vbl_.file=file;

vbl_.label='#SFC#VBL';
vbl_.prot=1;
vbl_.coding=0;

if ~isfield(vbl_,'len')
    vbl_.len=0;
end
if ~isfield(vbl_,'t0')
    vbl_.t0=0;
end
if ~isfield(vbl_,'dt')
    vbl_.dt=0;
end
if ~isfield(vbl_,'capt')
    vbl_.capt='nocapt';
end


vbl_=sfc_openw_c(file,vbl_);
fid=vbl_.fid;ftell(fid)

for i = 1:vbl_.nch
    vbl_.ch(i).lenx=0;
    vbl_.ch(i).leny=0;
    if ~exist('vbl_.ch(i).dx')
        vbl_.ch(i).dx=0;
    end
    if ~exist('vbl_.ch(i).dy')
        vbl_.ch(i).dy=0;
    end
    if ~exist('vbl_.ch(i).inix')
        vbl_.ch(i).inix=0;
    end
    if ~exist('vbl_.ch(i).iniy')
        vbl_.ch(i).iniy=0;
    end
    if ~exist('vbl_.ch(i).type')
        vbl_.ch(i).type=0;
    end
    fwrite(fid,vbl_.ch(i).dx,'double');
    fwrite(fid,vbl_.ch(i).dy,'double');
    fwrite(fid,vbl_.ch(i).lenx,'int32');
    fwrite(fid,vbl_.ch(i).leny,'int32');
    fwrite(fid,vbl_.ch(i).inix,'double');
    fwrite(fid,vbl_.ch(i).iniy,'double');
    fwrite(fid,vbl_.ch(i).type,'int32');
    fprintf(fid,'%84s',vbl_.ch(i).capt);
end

vbl_.point0=ftell(fid);



function vbl_headblw_c(fid,nbl,tbl,point)
%VBL_HEADBLW  writes the block header
%
%   nbl    block number
%   tbl    block time
%   point  next block pointer

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fprintf(fid,'[BLN%011d]',nbl);
fwrite(fid,tbl,'double');
fwrite(fid,point,'int64');


function vbl_headchw_c(fid,ch,point)
%VBL_HEADCHW  writes the channel header (no special)
%
%   ch      channel data 
%     .numb
%     .dx 
%     .dy 
%     .lenx 
%     .leny
%     .inix 
%     .iniy 
%     .type
%   point   next channel pointer

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fprintf(fid,'[CH%04d]',ch.numb);
fwrite(fid,point,'int64');
fwrite(fid,ch.dx,'double');
fwrite(fid,ch.dy,'double');
fwrite(fid,ch.lenx,'int32');
fwrite(fid,ch.leny,'int32');
fwrite(fid,ch.inix,'double');
fwrite(fid,ch.iniy,'double');
fwrite(fid,ch.type,'int32');


function vbl_closew_c(vbl_,blpoint,nblocks)
% VBL_CLOSEW closes a vbl file with the index of blocks
%
%    vbl_closew(vbl_,blpoint,nblocks)
%
%    vbl_      the vbl structure
%    blpoint   array of the block pointers
%    nblocks   number of blocks

fwrite(vbl_.fid,blpoint,'int64');
fwrite(vbl_.fid,nblocks,'int64');
fprintf(vbl_.fid,'[-INDEX]');

fclose(vbl_.fid);


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