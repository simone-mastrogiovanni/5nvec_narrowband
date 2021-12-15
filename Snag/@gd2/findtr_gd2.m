function [i1,j1,v1]=findtr_gd2(varargin)
%GD/FINDTR_GD2  find on a transposed sparse matrix gd2
%
%      [i1,j1,y1]=find_gd2(varargin)
%
%  arg1   gd2 in
%  arg2   min1
%  arg3   max1
%  arg4   min2
%  arg5   max2
%
%      [i1,j1,y1]   indices and value

% Version 1.0 - September 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

if length(varargin) == 5
   min1=varargin{2};
   max1=varargin{3};
   min2=varargin{4};
   max2=varargin{5};
   [i1,j1,y1]=find(g.y(min1:max1,min2:max2)');
else
   [i1,j1,v1]=find(g.y');
end
