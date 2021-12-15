function a=rota(b,n)
%ROTA  rotation of a vector
%
%     a=rota(b,n)
%
%  with a shift of 1, [1 2 3 4] -> [4 1 2 3]
%
%  b   input vector
%  n   number of shifts (rightward)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

l=length(b);
a=b;

if n > 0
   a(n+1:l)=b(1:l-n);
   a(1:n)=b(l-n+1:l);
elseif n < 0
   a(1:l+n)=b(-n+1:l);
   a(l+n+1:l)=b(1:-n);
end
