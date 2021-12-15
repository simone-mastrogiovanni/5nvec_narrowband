function g=smooth_hist(dat,par,nofig)
%SMOOTH_HIST   smooth histogramming (or pulse data smoothing)
%
%   dat    data array
%   par    parameters:  [bin number, delta, initial value, final value, type]
%                       type = 1 (triangle), 2 (cos+1)/2, 3 exp(||)
%   nofig  = 1 no figure
%
%   g      output gd

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dat=dat(:);
n=1024;
delt=100;
ini=min(dat);
fin=max(dat);
DT=fin-ini;
ini=ini-DT/(2*delt);
fin=fin+DT/(2*delt);
typ=1;

if ~exist('nofig')
    nofig=0;
end

if exist('par')
    l=length(par);
    n=par(1);
    if l > 1
        delt=par(2);
    end
    if l > 2
        ini=par(3);
    end
    if l > 3
        fin=par(4);
    end
    if l > 4
        typ=par(5);
    end
end

if ini == fin
	ini=min(dat);
	fin=max(dat);
	DT=fin-ini;
	ini=ini-DT/(2*delt);
	fin=fin+DT/(2*delt);
end

DT=fin-ini;
dt=DT/n;
x=ini+(0:n-1)*dt;
g=x*0;

ii=floor((dat-ini)/dt)+1;
iii=find(ii>0 & ii<=n);
ii=ii(iii);
if nofig ~= 1
    disp(sprintf('used %d events out of %d',length(ii),length(dat)));
end
N=length(ii);

for i = 1:length(ii)
    g(ii(i))=g(ii(i))+1;
end

if nofig ~= 1
    figure
    plot(x,g),hold on
end

nn=ceil(delt/dt)-1;
if nn <= 0
    nn=1;
    disp('the delta is too narrow')
end

y=(0:nn);

switch typ
    case 1
        y=1-y/nn;
    case 2
        y=(cos(y*pi/nn)+1)/2;
    case 3
        nn0=nn;
        nn=nn*4;
        y=0:nn;
        y=exp(-y/nn0);
end

y(nn+1:n)=0;n,nn
y(n:-1:n-nn+1)=y(2:nn+1);

y=fft(y);
g=fft(g);
g=ifft(g.*y);
g=real(g);
A=mean(g);
g=(g/A)*N/DT;

if nofig ~= 1
	if max(g) < 0.5
        figure
	end
	
	plot(x,g,'r'),grid on
end

g=gd(g);
g=edit_gd(g,'x',x,'capt','smooth histogram');
