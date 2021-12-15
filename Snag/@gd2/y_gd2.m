function a=y_gd2(varargin)
%GD/Y_GD2 ordinate
%
%  arg1   gd2 in
%  arg2   min1
%  arg3   max1
%  arg4   min2
%  arg5   max2

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

if length(varargin) == 5
   min1=varargin{2};
   max1=varargin{3};
   min2=varargin{4};
   max2=varargin{5};
   a=g.y(min1:max1,min2:max2);
else
   a=g.y;
end
