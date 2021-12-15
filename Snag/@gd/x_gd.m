function a=x_gd(varargin)
%GD/X_GD abscissa
%
%  arg1   gd in
%  arg2   min
%  arg3   max

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

if g.type == 2
   if length(varargin) == 3
      min=varargin{2};
      max=varargin{3};
      a=g.x(min:max);
   else
      a=g.x;
   end
elseif g.type == 1
   if length(varargin) == 3
      min=varargin{2};
      max=varargin{3};
      a=((min:max)-1)*g.dx+g.ini;
   else
      a=(0:g.n-1)*g.dx+g.ini;
   end
else
   error('gd type not defined');
end

a=a(:);
