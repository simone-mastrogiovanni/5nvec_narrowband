function a=x2_gd2(varargin)
%GD2/X2_GD2 secondary abscissa
%
%  arg1   gd in
%  arg2   min
%  arg3   max

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

g=varargin{1};

if length(varargin) == 3
  min=varargin{2};
  max=varargin{3};
  a=(min-1:max-1)*g.dx2+g.ini2;
else
  a=(0:g.m-1)*g.dx2+g.ini2;
end
   
a=a(:);
