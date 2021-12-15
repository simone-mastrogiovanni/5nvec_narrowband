function a=inte_gd(b)
%GD/INTE_GD  integral (rectangular approximation)
%
%       a=inte_gd(b)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
n=a.n;

a.y=cumsum(b.y);
d=diff(x_gd(a));

a.y(1)=a.y(1).*d(1);
a.y(2:n)=a.y(2:n).*d;