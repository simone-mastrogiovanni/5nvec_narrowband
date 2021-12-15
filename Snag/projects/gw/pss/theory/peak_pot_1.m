function [pot,out]=peak_pot_1(lambda,thr,dx)
%PEAK_POT   probability of spectral peaks over a threshold
%
%    lambda  signal spectral amplitude
%    xmax    max peak amplitude (a value at which the cdf is about 1)
%    dx      resolution  
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

% Snag Version 2.0 - February 2016 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

xmax=(7+lambda*2)*1.2;
x=0:dx:xmax;
n=length(x);
y1=2*ncx2pdf(2*x,2,2*lambda);
y2=y1.*((1-exp(-x)).^2);
ithr=round(thr/dx)+1;
pot=sum(y2(ithr:n))*dx;
y=cumsum(y2(length(y1):-1:1))*dx;
y=y(length(y):-1:1);
out.n=n;
out.ithr=ithr;
out.x=x;
out.y=y;
out.y1=y1;
out.y2=y2;
