function gout=gd_cutzero(gin)
% GD_CUTZERO  cuts zero data from a gd

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);

i=find(y);
y=y(i);

gout=gd(y);
gout=edit_gd(gout,'dx',dx_gd(gin),'capt',['cuts zeros off the ' capt_gd(gin)]);