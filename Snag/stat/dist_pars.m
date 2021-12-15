function pars=dist_pars(x,y)
% parameters from a distribution
%
%  x,y   x and y of the distribution (equispaced)
%          or
%  x     distrinution type 1 gd 

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~isreal(x)
    y=y_gd(x);
    x=x_gd(x);
end

n=length(y);
dx=(x(n)-x(1))/(n-1);
N=sum(y)*dx;
p=y*dx/N;
p=p/sum(p);
mu=sum(p.*x);
sd=sqrt(sum(p.*(x-mu).^2));
ncmom=ceil(sqrt(n));
cmom(1)=0;
for k = 2:ncmom
    cmom(k)=sum(p.*(x-mu).^k);
end

pars.p=p;
pars.N=N;
pars.mu=mu;
pars.sd=sd;
pars.sk=cmom(3)/sd^3;
pars.ku=cmom(4)/sd^4-3;
pars.cmom=cmom;