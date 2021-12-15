function display_ds(d)
%DS/DISPLAY_DS    display a ds
%
%     display_ds(d)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

le=sprintf('%d',d.len);
lc=sprintf('%d',d.lcw);
dt=sprintf('%d',d.dt);
ty=sprintf('%d',d.type);
disp([' ds ',inputname(1),' -> len=',le,' last=',lc,' dt=',dt,...
   ' type=',ty,' -> ',d.capt])