function r=gen_pareto(pow,par,typ,n)
%GEN_PARETO  generates n random Pareto numbers (power law)
%
%    r=gen_pareto(pow,par,typ,n)
%
%    pow    power (positive)
%    par    range parameter
%    typ    type ('pareto','parlin','parconst','parr1','parr2')
%    n      number of samples


% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random
a=rand(1,n);
dx=0.1/par;
switch typ
    case 'pareto'
        x=par:dx:par*400/pow;
        x1=par;
    otherwise
        x=0:dx:par*50;
        x1=0;
end
            
pdf=powlaw_dist(x,pow,par,typ);
F=cumsum(y_gd(pdf))*dx;
F=F/max(F); % size(F), figure,plot(x,F,'x'),grid on
N=length(F);
x=x1+(0:N-1)*dx;

r=spline(F,x,a);