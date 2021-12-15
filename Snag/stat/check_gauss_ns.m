function [sig,sigmf,mf,sig0,sig0ar,pdist,pzero,h,xh]=check_gauss_ns(a,den,lenmin,taus)
% CHECK_GAUSS_NS  checks for the presence of a (disturbed non-stationary) real gaussian process
%
%   [sig,sigmf,mf,sig0,sig0ar,pdist,pzero,h,xh]=check_gauss_ns(a,den,lenmin,taus)
%
%    a        the data (array or gd)
%    den      density of log bins (bins per unit interval)
%    lenmin   length of base pieces
%    taus     memory tau (in unit of lenmin)
%
%    sig      dev.st. from mean
%    sigmf    dev.st. from matched filter
%    mf       value of the matched filter (normalized to 1 for a gaussian process)
%    pdist    disturbance fraction
%    outzero  zero data
%    h        histogram
%    xh       abscissa of the histogram

% Version 2.0 - December 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icgd=0;
if isobject(a)
    icgd=1;
    inix=ini_gd(a);
    dt=dx_gd(a);
    a=y_gd(a);
else
    inix=0;
    dt=1;
end

M=length(taus);
w=exp(-1./taus);

a=a(:);
a1=a;
N0=length(a);

L=ceil(N0/lenmin);

[i1 i2 a]=find(a);
outzero1=find(~a1);
N=length(a);
pzero1=(N0-N)/N0;
loga=log(abs(a));
sig1=exp(mean(loga)+2/pi);
minla=min(loga);
maxla=max(loga);
dx=1/den;
ini=floor(minla/dx);
n=ceil((maxla-minla)/dx);
xh=(ini:ini+n)*dx;
ii=find(xh>1.5); % ?

ini2=floor(-1.5/dx);
fin2=floor(6/dx);
x2=(ini2:fin2)*dx;
f=sqrt(2/pi).*exp(-x2).*exp(-exp(-2*x2)/2);

jj=0;
kk=0;
h=zeros(n+1,M);
h0=h;
pzero=zeros(L,1);
sig0=pzero;
sig=zeros(L,M);
sigmf=sig;
mf=sig;
pdist=sig;
mloga1=sig;
mloga=sig;
sig0ar=sig;
sig0ar1=sig;
NN=ones(1,M);

while jj < N
    kk=kk+1;
    aa=a(jj+1:min(jj+lenmin,N));
    sig0(kk)=std(aa);
    jj=jj+lenmin;
    ll0=length(aa);
    [i1 i2 aa]=find(aa);
    ll=length(aa);
    loga=log(abs(aa));
    h1=hist(loga,xh)/length(aa);%size(h1),size(h0),size(xh)
    pzero(kk)=(ll0-ll)/ll0;
    
    for i = 1:M
        h0(:,i)=h0(:,i).*w(i)+h1';
        h(:,i)=h0(:,i)./NN(i);
        mloga1(i)=mloga1(i).*w(i)+mean(loga);
        mloga(i)=mloga1(i)./NN(i);
        NN(i)=NN(i)*w(i)+1;
        
        sig0ar1(kk,i)=sig0ar1(kk,i)*w(i)+sig0(kk)^2;
        sig0ar(kk,1)=sqrt(sig0ar1(kk,i)/NN(i));
        sig(kk,i)=exp(mloga(i)+2/pi);
        pdist(kk,i)=sum(h(:,i));
        
        y=conv(h(:,i),f);

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
        [mf1 ii1]=max(y1*enl);
        mf(kk,i)=mf1*(1+pdist(kk,i))*pi;
        sigmf(kk,i)=exp((ii1+(ini2+ini)*enl-1)*dx/enl);
    end
end

% if icgd == 1
%     dt1=dt*lenmin;
%     sig=gd(sig);
%     sig=edit_gd(sig,'ini',inix,'dx',dt1);
%     sigmf=gd(sigmf);
%     sigmf=edit_gd(sigmf,'ini',inix,'dx',dt1);
%     mf=gd(mf);
%     mf=edit_gd(mf,'ini',inix,'dx',dt1);
%     sig0=gd(sig0);
%     sig0=edit_gd(sig0,'ini',inix,'dx',dt1);
%     sig0ar=gd(sig0ar);
%     sig0ar=edit_gd(sig0ar,'ini',inix,'dx',dt1);
%     pdist=gd(pdist);
%     pdist=edit_gd(pdist,'ini',inix,'dx',dt1);
%     pzero=gd(pzero);
%     pzero=edit_gd(pzero,'ini',inix,'dx',dt1);
% end