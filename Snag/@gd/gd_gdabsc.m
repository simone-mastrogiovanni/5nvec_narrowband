function g=gd_gdabsc(gd_1,gd_2)
%GD_GDABSC  creates a gd with gd_1 ordinate as abscissa and the gd_2 as ordinate
%
%      g=gd_gdabsc(gd_1,gd_2)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=gd_2;

g.type=2;
g.capt=[gd_2.capt '-New Abscissa'];

g.x=gd_1.y;