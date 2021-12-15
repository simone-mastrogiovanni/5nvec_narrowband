function g=w_gd(g,min,max,y)
%GD/W_GD  writes in a gd.y in the section min:max
%
% the gd is type 1

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g.y(min:max)=y;
g.y=g.y(:);