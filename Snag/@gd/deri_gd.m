function a=deri_gd(b)
%GD/DERI_GD  derivative

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;

a.y(2:a.n)=diff(b.y);
a.y(1)=a.y(2);

a.y=a.y./a.dx;