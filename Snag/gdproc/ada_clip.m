function [gout ssigmf]=ada_clip(gin,den,lenstat,cr,typ)
% ADA_CLIP  adaptive clipping, for disturbed zero mean gaussian processes
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

gin=gin(:);
N0=length(gin);
L=ceil(N0/lenstat);

i1=find(gin);
a=gin(i1);

N=length(a);
loga=log(abs(a));
minla=min(loga);
maxla=max(loga);
dx=1/den;
ini=floor(minla/dx);
n=ceil((maxla-minla)/dx);
xh=(ini:ini+n)*dx;

ini2=floor(-1.5/dx);
fin2=floor(6/dx);
x2=(ini2:fin2)*dx;
f=sqrt(2/pi).*exp(-x2).*exp(-exp(-2*x2)/2);

jj=0;
kk=0;
h0=zeros(n+1,1);
sigmf=zeros(L,1);
NN=1;%N0,N,L

while jj < N
    kk=kk+1; %perc=100*jj/N
    aa=a(jj+1:min(jj+lenstat,N));
    jj=jj+lenstat;
%     [j1 j2 aa]=find(aa);
    loga=log(abs(aa));
    h1=hist(loga,xh)/length(aa);%size(h1),size(h0),size(xh)

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
    sigmf(kk)=exp((jj1+(ini2+ini)*enl-1)*dx/enl);
end

sigmf=sigmf(1:kk);
i2=i1(1:lenstat:length(i1));%kk,size(i1),size(i2),size(sigmf)
ssigmf=interp1(i2,sigmf,i1);
nclip=length(i2);

ii1=find(abs(a)>cr*ssigmf);

switch typ
    case 0
        a(ii1)=ssigmf(ii1).*cr.*sign(a(ii1));
    case 1
        a(ii1)=0;
    case 2
        disp('not yet implemented')
    case 3
        disp('not yet implemented')
end

gin(i1)=a;


if isgd == 1
    gout=edit_gd(gout,'y',gin);
else
    gout=gin;
end

disp(sprintf(' %d input data',N0))
disp(sprintf(' %d zero data; perc.: %f ',N0-N,(N0-N)/N0))
disp(sprintf(' %d clipped data; perc.: %f ',nclip,nclip/N0))