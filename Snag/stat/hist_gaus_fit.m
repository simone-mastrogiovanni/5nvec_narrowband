function [g,p,N,mu,sd,dh]=hist_gaus_fit(h,xh)
% gaussian fit for (uniform) histograms and parts of
%
%   h    histogram (or part of)
%   xh   hist abscissas

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

N=sum(h);
n=length(h);
dh=(xh(n)-xh(1))/(n-1);
p=h/N;
mu=sum(p.*xh);
sd=sqrt(sum(p.*(xh-mu).^2));

g = normpdf(xh,mu,sd);
sumg=sum(g);
g=g*N/sumg;
