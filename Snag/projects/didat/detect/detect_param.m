function [dp maxdpx maxdpy]=detect_param(fap,sigs)
% DETECT_PARAM  computes the detection parameter
%  
%   fap      false alarm probability
%   sigs     signals
%
%   dp       detection parameter for each signal
%   maxdpx   max dp abcissa (optimal threshold)
%   maxdpy   max dp value

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ns=length(sigs);

dx=dx_gd(fap);
ini=ini_gd(fap);
nf=n_gd(fap);
fap=y_gd(fap);
d0=round(-ini/dx);
d1=round(sigs/dx);
d1max=max(d1);
nf1=nf-d1max;
dp=zeros(ns,nf1);
maxdpx=zeros(1,ns);
maxdpy=maxdpx;
fa=fap(d1max+1:nf);
sqr=sqrt(fa.*(1-fa)+realmin);
% sqr(find(sqr==0))=realmin;

for i = 1:ns
    p=fap(d1max+1-d1(i):nf-d1(i));%size(p)
    dp(i,1:nf1)=(p-fa)./sqr;
    [maxdpy(i) maxdpx(i)]=max(dp(i,:));
end

maxdpx=(maxdpx-1)*dx+ini+d1max*dx;

