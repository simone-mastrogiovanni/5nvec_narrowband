function [gout gsigmf]=ada_clip_c(gin,den,lenstat,cr,typ)
% ADA_CLIP_C  adaptive clipping, for disturbed zero mean complex gaussian processes
%
%      gout=ada_clip(gin,den,lenstat,cr,typ)
%
%   gin       input gd or array
%   den       density of log bins (bins per unit interval, typically 10)
%   lenstat   length of stationarity (number of samples) 
%   cr        critical ratio for clipping
%   typ       type of clipping:
%              0 -> clipped value (default)
%              1 -> zero
%              2 -> interpolate    ! NOT YET IMPLEMENTED
%              3 -> eliminate data ! NOT YET IMPLEMENTED

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isa(gin,'gd')
    dx=dx_gd(gin);
    init=ini_gd(gin);
    gout=gin;
    isgd=1;
    gin=y_gd(gin);
else
    dx=1;
    init=0;
    isgd=0;
end

if ~exist('typ','var')
    typ=0;
end

w=exp(-1./lenstat);

rgin=real(gin(:));
igin=imag(gin(:));
N0=length(gin);
L=ceil(N0/lenstat);

ir1=find(rgin);
ar=rgin(ir1);
ii1=find(igin);
ai=igin(ii1);

Nr=length(ar);
logar=log(abs(ar));
minlar=min(logar);
maxlar=max(logar);
Ni=length(ai);
logai=log(abs(ai));
minlai=min(logai);
maxlai=max(logai);

dx=1/den;

inir=floor(minlar/dx);
nr=ceil((maxlar-minlar)/dx);
xhr=(inir:inir+nr)*dx;
inii=floor(minlai/dx);
ni=ceil((maxlai-minlai)/dx);
xhi=(inii:inii+ni)*dx;

ini2=floor(-1.5/dx);
fin2=floor(6/dx);
x2=(ini2:fin2)*dx;
f=sqrt(2/pi).*exp(-x2).*exp(-exp(-2*x2)/2);

sigmfr=zeros(L,1);
sigmfi=zeros(L,1);

h0=zeros(nr+1,1);
jj=0;
kk=0;
NN=1; %figure

while jj < Nr
    kk=kk+1;
    aa=ar(jj+1:min(jj+lenstat,Nr));
    jj=jj+lenstat;
%     [j1 j2 aa]=find(aa);
    loga=log(abs(aa));
    h1=hist(loga,xhr)/length(aa);
    h0=h0*w+h1.'; % plot(h0),drawnow
    h=h0/NN;
    NN=NN*w+1;

    y=conv(h,f);

    ny=length(y);
    if floor(ny/2)*2 ~= ny
        y(ny+1)=0;
        ny=ny+1;
    end
    
    enl=100;
    y1=fft(y);
    nyy=ny*enl;
    y1(ny+1:nyy)=0;
    y1(nyy:-1:nyy-ny/2+2)=y1(ny:-1:ny/2+2);
    y1(ny/2+1:ny)=0;
    y1=ifft(y1);
    [mf1 jj1]=max(y1*enl);
    sigmfr(kk)=exp((jj1+(ini2+inir)*enl-1)*dx/enl);
end

sigmfr=sigmfr(1:kk);
i2r=ir1(1:lenstat:length(ir1)); % max(i2r),max(ir1)
ssigmfr=interp1(i2r,sigmfr,ir1);
nclipr=length(i2r);

jj1r=find(abs(ar)>cr*ssigmfr);

h0=zeros(ni+1,1);
jj=0;
kk=0;
NN=1;

while jj < Ni
    kk=kk+1;
    aa=ai(jj+1:min(jj+lenstat,Ni));
    jj=jj+lenstat;
%     [j1 j2 aa]=find(aa);
    loga=log(abs(aa));
    h1=hist(loga,xhi)/length(aa);

    h0=h0*w+h1.';
    h=h0/NN;
    NN=NN*w+1;

    y=conv(h,f);

    ny=length(y);
    if floor(ny/2)*2 ~= ny
        y(ny+1)=0;
        ny=ny+1;
    end
    
    enl=100;
    y1=fft(y);
    nyy=ny*enl;
    y1(ny+1:nyy)=0;
    y1(nyy:-1:nyy-ny/2+2)=y1(ny:-1:ny/2+2);
    y1(ny/2+1:ny)=0;
    y1=ifft(y1);
    [mf1 jj1]=max(y1*enl);
    sigmfi(kk)=exp((jj1+(ini2+inii)*enl-1)*dx/enl);
end

sigmfi=sigmfi(1:kk);
i2i=ii1(1:lenstat:length(ii1));
ssigmfi=interp1(i2i,sigmfi,ii1);
nclipi=length(i2i);

jj1i=find(abs(ai)>cr*ssigmfi);

switch typ
    case 0
        ar(jj1r)=ssigmfr(jj1r).*cr.*sign(ar(jj1r));
        ai(jj1i)=ssigmfi(jj1i).*cr.*sign(ai(jj1));
    case 1
        ar(jj1)=0;
        ai(jj1)=0;
    case 2
        disp('not yet implemented')
    case 3
        disp('not yet implemented')
end

rgin(ir1)=ar;
igin(ii1)=ai;
gin=rgin+1i*igin;
gsigmf=gin*0;
gsigmf(ii1)=ssigmfi;
gsigmf(ir1)=ssigmfr;
out=check_nan(gsigmf,1);
gsigmf(out)=0;

if isgd == 1
    gout=edit_gd(gout,'y',gin);
    gsigmf=edit_gd(gout,'y',gsigmf,'capt','Gaussian noise standard deviation');
else
    gout=gin;
end

fprintf(' %d input data \n',N0)
fprintf(' %d %d zero data; perc.: %f %f \n',N0-Nr,N0-Ni,(N0-Nr)/N0,(N0-Ni)/N0)
fprintf(' %d %d clipped data; perc.: %f %f \n',nclipr,nclipi,nclipr/N0,nclipi/N0)
% figure,plot((sigmfr+sigmfi)),grid on