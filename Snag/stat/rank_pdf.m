function [r,x]=rank_pdf(x,nant,N)
% ranking pdf (on log10)
%
%   x     abscissas (in log10; def (0.1:0.1:10)-0.05)
%   nant  nunber of antennas (def 2)
%   N     number of samples (def 1000000)

% Snag Version 2.0 - July 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('x','var')
    x=(0.1:0.1:10)-0.05;
end
if ~exist('nant','var')
    nant=2;
end
if ~exist('N','var')
    N=1000000;
end

r1=randperm(N)/N;
r2=1./r1;
for i = 2:nant
    r1=randperm(N)/N;
    r2=r2./r1;
end

r=hist(log10(r2),x);