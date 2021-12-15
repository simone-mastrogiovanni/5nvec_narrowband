function r=gen_random_pdf(f,x0,dx,n)
%GEN_RANDOM  generates n random numbers with the distribution
%            function f (not necessarily normalized)
%
%   x0,dx   min abscissa, step for f

% Version 2.0 - June 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

F=cumsum(f)/sum(f);
a=rand(1,n);
N=length(F);

x=x0+(0:N-1)*dx;%figure,plot(F,x),hold on,plot(F,x,'rx')

r=interp1(F+(0:N-1)/(1000*N),x,a);

