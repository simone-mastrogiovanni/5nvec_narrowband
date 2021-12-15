function [sig,sigmf,mf,pdist,pzero,out,outzero,h,xh]=check_gauss(a,den)
% CHECK_GAUSS  checks for the presence of a (disturbed)gaussian process
%
%   [sig,sigmf,mf,pdist,pzero,out,outzero,h,xh]=check_gauss(a,den)
%
%    a        the data (array or gd)
%    den      density of log bins (bins per unit interval)
%
%    sig      dev.st. from mean
%    sigmf    dev.st. from matched filter
%    mf       value of the matched filter (normalized to 1 for a gaussian process)
%    pdist    disturbance fraction
%    out      filtered data indices (internal to thresh = +-6 sigma)
%    outzero  zero data
%    h        histogram
%    xh       abscissa of the histogram

% Version 2.0 - June 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isobject(a)
    a=y_gd(a);
end

a=a(:);
a1=a;
N0=length(a);
[i1 i2 a]=find(a);
outzero=find(~a1);
N=length(a);
pzero=(N0-N)/N0;
loga=log(abs(a));
sig=exp(mean(loga)+2/pi);
minla=min(loga);
maxla=max(loga);
dx=1/den;
ini=floor(minla/dx);
n=ceil((maxla-minla)/dx);
xh=(ini:ini+n)*dx;
h=hist(loga,xh)/N;
ii=find(xh>1.5);
pdist=sum(h(ii));

ini2=floor(-1.5/dx);
fin2=floor(6/dx);
x2=(ini2:fin2)*dx;
f=sqrt(2/pi).*exp(-x2).*exp(-exp(-2*x2)/2);

y=conv(h,f);
% [mf ii]=max(y)
% sigmf=exp((ii+ini2+ini-1)*dx);

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
[mf ii1]=max(y1*enl);
mf=mf*(1+pdist)*pi;
sigmf=exp((ii1+(ini2+ini)*enl-1)*dx/enl);


% figure,plot(x,h),hold on,grid on,plot(x2,f,'r')
out=find(a1<=6*sig & a1>=-6*sig);
