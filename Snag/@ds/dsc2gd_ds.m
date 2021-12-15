function g=dsc2gd_ds(d)
%DS/DSC2GD_DS  accesses a ds producing a gd containing the last chunk

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

y=y_ds(d);
g=gd(y);

dt=d.dt;
g=edit_gd(g,'dx',dt);