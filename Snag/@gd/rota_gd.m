function a=rota_gd(b,n)
%ROTA_GD  rotation of a gd
%
%  b   input gd
%  n   number of shifts (rightward)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
l=a.n;

if n > 0
   a.y(n+1:l)=b.y(1:l-n);
   a.y(1:n)=b.y(l-n+1:l);
elseif n < 0
   a.y(1:l+n)=b.y(-n+1:l);
   a.y(l+n+1:l)=b.y(1:-n);
end
