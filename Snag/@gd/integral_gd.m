function e=integral_gd(g)
% INTEGRAL_GD  computes the integral of a gd

% Version 2.0 - October 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=x_gd(g);
d=diff(x); 
n=g.n;

e=g.y(1)*g.dx+sum(d.*g.y(2:n));