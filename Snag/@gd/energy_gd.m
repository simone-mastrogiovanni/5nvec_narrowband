function e=energy_gd(g)
% ENERGY_GD  computes the energy of a gd (the integral of the square modulus)
%
%  for the power, use meanpower_gd

% Version 2.0 - October 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=x_gd(g);
d=diff(x); 
n=g.n;

e=g.y(1)*g.dx+sum(d.*(abs(g.y(2:n)).^2));