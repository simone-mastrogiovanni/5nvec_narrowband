function a=y_gd(varargin)
%GD/Y_GD ordinate
%
%  arg1   gd in
%  arg2   min
%  arg3   max

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

if length(varargin) == 3
   min=varargin{2};
   max=varargin{3};
   a=g.y(min:max);
else
   a=g.y;
end
