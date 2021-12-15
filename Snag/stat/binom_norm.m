function f=binom_norm(N,p,pd,bd)
% BINOM_NORM  binomial normalized pdf
%
%    f=binom_norm(N,p)
%
%   N,p     binomial parameters
%   pb,db   disturbance params (prob,amp)

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('pd','var')
    pd=0.0;
end
if ~exist('bd','var')
    bd=5;
end

sig=sqrt(N*p*(1-p));
mu=N*p;
f=binopdf(0:N,N,p)*sig;

dx=1/sig;
ini=-mu/sig;

x=ini+dx*(0:N);
ip=find(x>=0);
f(ip)=pd*exp(-abs(x(ip)/bd))/bd+(1-p)*f(ip);

f=gd(f);
f=edit_gd(f,'ini',ini,'dx',dx,'capt','normalized binomial');


