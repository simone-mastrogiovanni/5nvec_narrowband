function piapeak2vbl(dfr,lfft,piafile,filout)
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

if ~exist('piafile')
    piafile=selfile('  ');
end
piafid=fopen(piafile);

if ~exist('filout')
    filout='peakmap.vbl';
end

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

vbl_=vbl_openw(filout,vbl_);

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
    vbl_headblw(vbl_.fid,i,mjd,nextblock)
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
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,v,'double');
    
    chpoint=chpoint+60+nmax*4;
    ch.numb=2;
    ch.lenx=length(b);
    ch.inix=inix;
    ch.type=3;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,b,'int32');
    
%     chpoint=chpoint+60+nmax*4;
    chpoint=0;
    ch.numb=3;
    ch.lenx=length(a);
    ch.inix=0;
    ch.type=4;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,a,'float32');
    
    blp=blp+blocklength;
end

% fwrite(vbl_.fid,blpoint,'int64');
% fwrite(vbl_.fid,nfft,'int64');
% fprintf(vbl_.fid,'[-INDEX]');
% 
% fclose(vbl_.fid);

vbl_closew(vbl_,blpoint,nfft);