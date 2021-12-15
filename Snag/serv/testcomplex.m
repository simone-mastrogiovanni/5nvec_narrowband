function tf=testcomplex(g)
%TESTCOMPLEX  test if the object is complex
%
%        tf=testcomplex(g)
%
%     g    a double array, a gd or a gd2
%     tf   1 if complex, 0 if real

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tf=0;

if isa(g,'double') == 1
   s=any(imag(g(:)));
end

if isa(g,'gd') == 1
   y=y_gd(g);
   s=any(imag(y(:)));
end

if isa(g,'gd2') == 1
   y=y_gd2(g);
   s=any(imag(y(:)));
end

if s > 0
   tf=1;
end

