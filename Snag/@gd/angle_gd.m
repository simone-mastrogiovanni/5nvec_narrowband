function a=angle_gd(b)
%GD/ANGLE_GD  absolute value

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
a.y=angle(b.y);
