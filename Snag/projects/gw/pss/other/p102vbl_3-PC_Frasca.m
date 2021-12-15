function p102vbl_3(piafile,filout)
%
%   p092vbl(piafile,filout)
%
% p09 format:
%
%     Header
% nfft      int32
% sfr       double (sampling frequency)
% lfft2     int32 (original length of fft divided by 2)
% inifr     double
%
%   Block header
% mjd       double
% npeak     int32
% velx      double (v/c)
% vely      double (v/c)
% velz      double (v/c)
% posx      double (x/c)
% posy      double (y/c)
% posz      double (z/c)
%
%   Short spectrum (unilateral, in Einstein^2)
% spini     double
% spdf      double
% splen     int32
% sp        float (splen values)
%
%     Data (npeak times)
% bin       int32
% ratio     float
% xamed     float (mean of H)

% Version 2.0 - March 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit? "Sapienza" - Rome

if ~exist('piafile','var')
    piafile=selfile('  ');
end
piafid=fopen(piafile)
 [FILENAME,PERMISSION,MACHINEFORMAT,ENCODING] =fopen(piafid)
if ~exist('filout','var')
    filout='peakmap.vbl';
end

inix=0;
vbl_.nch=6;
vbl_.capt=['from ' piafile ' Pia file'];

nfft=fread(piafid,1,'int32')
%nfft=fread(piafid,1,'int32');
vbl_.len=nfft;
sfr=fread(piafid,1,'double')
lfft2=fread(piafid,1,'int32')
dfr=sfr/(lfft2*2); % nfft,sfr,lfft2,dfr
inifr=fread(piafid,1,'double')


iiii=ftell(piafid);
mjd=fread(piafid,1,'double')
npeak=fread(piafid,1,'int32')
vp=fread(piafid,6,'double')
spini=fread(piafid,1,'double')
spdf=fread(piafid,1,'double')
splen=fread(piafid,1,'int32')

vbl_.ch(1).capt='DETV detector velocity and position';
vbl_.ch(2).capt='SHORTSP short spectrum';
vbl_.ch(3).capt='INDEX to peakbin vector';
vbl_.ch(4).capt='PEAKBIN peak frequency bin';
vbl_.ch(5).capt='PEAKCR equalized peak amplitude';
vbl_.ch(6).capt='PEAKMEAN mean value at the peak';

vbl_.ch(1).type=6;
vbl_.ch(1).lenx=6;
vbl_.ch(2).type=4;
vbl_.ch(2).lenx=splen;
vbl_.ch(2).dx=spdf;
vbl_.ch(2).inix=spini;
vbl_.ch(3).type=3;
vbl_.ch(3).lenx=splen;
vbl_.ch(3).dx=spdf;
vbl_.ch(3).inix=spini;
vbl_.ch(4).dx=dfr;
vbl_.ch(4).lenx=lfft2;
vbl_.ch(4).type=3;
vbl_.ch(4).dx=dfr;
vbl_.ch(5).type=4;
vbl_.ch(6).type=4;

edge=(0:splen)*(lfft2/splen);
ind=zeros(splen,1);

ch.dy=0;
ch.inix=0;
ch.iniy=0;
ch.lenx=0;
ch.leny=0;
ch.type=0;
ch.point=0;

vbl_=vbl_openw(filout,vbl_);

blpoint=zeros(1,nfft);
blp=vbl_.point0;
fseek(piafid,iiii,'bof');

for i = 1:nfft
    blpoint(i)=blp;
    
    mjd=fread(piafid,1,'double');
    npeak=fread(piafid,1,'int32');   
    vp=fread(piafid,6,'double'); 
    spini=fread(piafid,1,'double');
    spdf=fread(piafid,1,'double');
    splen=fread(piafid,1,'int32');
    sp=fread(piafid,splen,'float32');
    if(npeak>0)
        blocklength=32+60*6+6*8+(splen*2)*4+npeak*(4+4+4);
    else
        blocklength=32+60*6+6*8+(splen*2)*4+1*(4+4+4);
    end
    nextblock=blp+blocklength;
    if i == nfft
        nextblock=0;
    end
    
    vbl_headblw(vbl_.fid,i,mjd,nextblock)
    if npeak >0
        a=zeros(1,npeak);
        b=a;
        m=a; %%pia
    else
        a=zeros(1,1);
        b=a;
        m=a;
    end
%     for j = 1:npeak
%         b(j)=fread(piafid,1,'int32');
%         a(j)=fread(piafid,1,'float');
%         m(j)=fread(piafid,1,'float');
%     end
    if(npeak>0)
        b=fread(piafid,npeak,'int32');
        a=fread(piafid,npeak,'float');
        m=fread(piafid,npeak,'float');
    else
        display('no peaks in this fft !'); 
    end
    if length(b) <= 0
        blp=blp+blocklength;
        fprintf(' *** Error in %d fft \n',i)
        continue
    end
    
    his=histc(b,edge);
    ind(2:splen)=cumsum(his(1:splen-1));
    ind(1)=0;
    
    chp=ftell(vbl_.fid);
    chpoint=chp+60+6*8;
    ch.numb=1;
    ch.lenx=length(vp);
    ch.inix=0;
    ch.dx=0;
    ch.type=6;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,vp,'double');
    
    chpoint=chpoint+60+splen*4;
    ch.numb=2;
    ch.lenx=splen;
    ch.inix=spini;
    ch.dx=spdf;
    ch.type=4;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,sp,'float32');
    
    chpoint=chpoint+60+splen*4;
    ch.numb=3;
    ch.type=3;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,ind,'int32');
    if npeak >0
        chpoint=chpoint+60+npeak*4;
        else
       chpoint=chpoint+60+1*4; 
    end
    ch.numb=4;
    ch.lenx=length(b);
    ch.inix=inix;
    ch.dx=dfr;
    ch.type=3;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,b,'int32');
    
%     chpoint=chpoint+60+nmax*4;
    if npeak >0
        chpoint=chpoint+60+npeak*4;
    else
       chpoint=chpoint+60+1*4; 
    end
    ch.numb=5;
    ch.lenx=length(b);
    ch.inix=0;
    ch.type=4;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,a,'float32');
    
%     chpoint=chpoint+60+nmax*4; DA CONTROLLARE IL CHECKPOINT
    chpoint=0;
    ch.numb=6;
    ch.lenx=length(b);
    ch.inix=0;
    ch.type=4;
    vbl_headchw(vbl_.fid,ch,chpoint);
    fwrite(vbl_.fid,m,'float32');
    
    blp=blp+blocklength;
end

% fwrite(vbl_.fid,blpoint,'int64');
% fwrite(vbl_.fid,nfft,'int64');
% fprintf(vbl_.fid,'[-INDEX]');
% 
% fclose(vbl_.fid);

fclose(piafid);
vbl_closew(vbl_,blpoint,nfft);
