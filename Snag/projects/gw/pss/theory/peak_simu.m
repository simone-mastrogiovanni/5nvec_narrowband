function h=peak_simu(N,n,amax)
%PEAK_EXP histogram of simulated spectral peaks
%
%   N      spectral length
%   n      bins number
%   amax   maximum peak value

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random

y=(randn(1,N).^2+randn(1,N).^2)/2;

y1=rota(y,1);
y2=rota(y,-1);
y1=ceil(sign(y-y1)/2);
y2=ceil(sign(y-y2)/2);
y1=y1.*y2;
y=y.*y1;
y2=ceil(sign(y)/2);
y=y.*y2;
npeak=sum(y2)
[i1,j1,s1]=find(y);
y=s1;

dx=amax/(n-1);
x=0:dx:amax;

h=histc(y,x)/(npeak*dx);

figure,semilogy(x,h),hold on

t=peak_pdf(0,x+dx/2); semilogy(x,t,'r')

hlin=histc(sqrt(y),x)/(npeak*dx);

figure,loglog(x,hlin), grid on