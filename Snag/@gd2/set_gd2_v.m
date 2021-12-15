function g=set_gd2_vdetect(g,va,vd,ve)
%SET_GD2_V   sets the auxiliary variables for detector velocity (SFDB)
%
%       g=set_gd2_vdetect(g,long,lat,coord)
%
%    g           the gd2
%    va,vd,ve    detector's velocity celestial coordinates (degrees)
%
%  The variables set are g.va, g.vd, g.ve


% Version 1.0 - February 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g.va=va;
g.vd=vd;
g.ve=ve;