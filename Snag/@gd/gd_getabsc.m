function g=gd_getabsc(gd_1,gd_2)
%GD_GETABSC  creates a gd with the abscissa of gd1 and the ordinate of gd2
%
%      g=gd_getabsc(gd_1,gd_2)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=gd_2;

g.type=gd_1.type;
g.ini=gd_1.ini;
g.dx=gd_1.dx;
g.capt=[gd_2.capt '-New Abscissa'];

if gd_1.type == 2
   g.x=gd_1.x;
end
