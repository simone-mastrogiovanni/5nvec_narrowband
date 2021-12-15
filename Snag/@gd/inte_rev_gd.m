function a=inte_rev_gd(b)
%GD/INTE_GD  integral from x to infinite (rectangular approximation)
%             (e.g. for false alarm probability)
%
%       a=inte_rev_gd(b)

% Version 2.0 - June 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
n=a.n;

a.y=cumsum(b.y(n:-1:1));
d=diff(x_gd(a));
d=d(n-1:-1:1);

a.y(1)=a.y(1).*d(1);
a.y(2:n)=a.y(2:n).*d;
a.y=a.y(n:-1:1);