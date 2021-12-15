function gout=gd_resampling(gin,dtout,NMAX)
% GD_RESAMPLING  resamples a gd
%
%      gout=gd_resampling(gin,dt)
%
%   gin     input gd (data object)
%   dtout   desired sampling time
%   NMAX    max length of pieces (def 2^20)
%
%   gout    resampled gd (data object)
%
% The in and out sampling frequencies should be integer numbers

% Version 2.0 - February 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('NMAX','var')
    NMAX=2^20; 
end
NMAX=min(NMAX,n_gd(gin));
NMAX=ceil(NMAX/2)*2

dtin=dx_gd(gin);
frin=1/dtin;
nin=n_gd(gin);
ini=ini_gd(gin);
y=y_gd(gin);

frout=1/dtout;
nout=round(nin*frout/frin)

frmax=max(frin,frout);
nsec=min(ceil(max(nin,nout)/(2*frmax)),ceil(NMAX/(2*frmax)))*2 % an even number
ndat1=nsec*frin
ndat2=nsec*frout
nd2=min(ndat1,ndat2)/2;
ntotin=frin*ceil(nin/frin);
y(nin+1:ntotin)=0;
x1=zeros(1,ndat1*2);
x0=x1;
yfin=min(3*(ndat1/2),length(y));
dyfin=yfin-3*(ndat1/2);
x1(ndat1/2+1:2*ndat1+dyfin)=y(1:yfin)*frout/frin;
x2=zeros(1,ndat2*2);

iread=yfin;
iiout=0;

while iiout < nout
%     x1(ini1:ini1+ndat1-1)=y(ii+1:ii+ndat1)*frout/frin;
    x0=fft(x1);
    x0(nd2*2:(ndat1-nd2)*2+2)=0;
    x0(nd2*2-10:nd2*2-1)=x0(nd2*2-10:nd2*2-1).*(10:-1:1)/10;
    x2=zeros(1,ndat2*2);
    x2(1:nd2*2)=x0(1:nd2*2);
    x2(nd2*2:ndat2*2)=0;
    x2(1)=abs(x2(1));
    x2(ndat2*2:-1:ndat2+2)=conj(x2(2:ndat2));
    x2=ifft(x2);%figure,plot(x2)
    gout(iiout+1:iiout+ndat2)=x2(ndat2/2+1:3*ndat2/2);
    x1(1:ndat1)=x1(ndat1+1:2*ndat1);
    yfin=min(iread+ndat1,length(y));%size(x1),size(y)
    dyfin=yfin-iread-ndat1;
    if yfin > iread
        x1(ndat1+1:2*ndat1+dyfin)=y(iread+1:yfin)*frout/frin;
    end
    iread=iread+ndat1;
    iiout=iiout+ndat2;
end

gout=gd(gout(1:nout));
gout=edit_gd(gout,'dx',dtout,'ini',ini,'capt','resampled data');
