function g=edit_gd2(varargin)
%GD/EDIT_GD2 edits parameters of a gd2
%
% use always with ; and the output gd
% the first input argument must be the gd to edit
%
% keys (even arguments):
%  'x'
%  'y'
%  'n'
%  'type'
%  'ini'
%  'dx'
%  'capt'
%  'cont'
%  'm'
%  'ini2'
%  'dx2'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

if isnumeric(g)
    g=gd2(g);
end

for i = 2:2:length(varargin)
   strin=varargin{i};
   switch strin
      case 'x'
         g.x=varargin{i+1};
         g.type=2;
      case 'y'
         g.y=varargin{i+1};
         [n1 n2]=size(g.y);
         g.n=n1*n2;
         g.m=n2;
      case 'n'
         g.n=varargin{i+1};
      case 'type'
         g.type=varargin{i+1};
      case 'ini'
         g.ini=varargin{i+1};
      case 'dx'
         g.dx=varargin{i+1};
      case 'capt'
         g.capt=varargin{i+1};
      case 'cont'
         g.cont=varargin{i+1};
      case 'm'
         g.m=varargin{i+1};
      case 'ini2'
         g.ini2=varargin{i+1};
      case 'dx2'
         g.dx2=varargin{i+1};

   end
end

% display(g);