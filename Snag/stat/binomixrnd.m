function [r mu sig]=binomixrnd(N,p,M)
% BINOMIXPDF  random data from a mixing of binomial process
%
%     [r mu sig f1 mu1 sig1]=binomixrnd(N,p)
%
%   N         value of N
%   p         array of ps
%   M         array of Ms
%
%   r         random data
%   mu,sig    data parameters

% Version 2.0 - January 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(p);
MM=sum(M);
r=zeros(MM+1,1);
ii=0;

for i = 1:n
    r(ii+1:ii+M(i))=binornd(N,p(i),M(i),1);
    ii=ii+M(i);
end

mu=mean(r)
sig=std(r)
