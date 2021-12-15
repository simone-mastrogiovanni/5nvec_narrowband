function gas=ansig_gd(g)
%ANSIG_GD  creates the analytical signal from a real gd
%
%  g    input gd
%  gas  output gd

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gas=g;
gas.y=real2an(g.y);