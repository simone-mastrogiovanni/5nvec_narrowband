function r=gen_random(F,x0,dx,n)
%GEN_RANDOM  generates n random numbers with the integral distribution
%            function F
%
%   x0,dx   min abscissa, step for F

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=rand(1,n);
N=length(F);
%DX=(N-1)*dx;
x=x0+(0:N-1)*dx;

r=interp1(F+(0:N-1)/(1000*N),x,a);
