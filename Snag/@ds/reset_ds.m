function d=reset_ds(d)
%DS/RESET_DS  resets a ds
%  use as   "d=reset_ds(d)"

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d.tini1=-d.len*d.dt;
d.y1=zeros(1,5*d.len/4);
d.ind1=1;
d.nc1=0;
d.lcw=0;
d.tini2=-d.len;
d.y2=zeros(1,d.len);
d.ind2=1;
d.nc2=0;
d.lcr=0;
d.cont=0;