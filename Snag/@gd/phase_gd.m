function a=phase_gd(b)
%GD/PHASE_GD  phase angle in degrees

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
a.y=angle(b.y).*(180/pi);
