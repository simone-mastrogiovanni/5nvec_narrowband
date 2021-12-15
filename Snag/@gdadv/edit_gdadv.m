function g=edit_gdadv(varargin)
%GDADV/EDIT_GDADV edits parameters of a gdadv
%
% use always with ; and the output gdadv
% the first input argument must be the gdadv to edit
%
% keys (even arguments):
%  'x'
%  'y'
%  'n'
%  'type'
%  'ini'
%  'dx'
%  'capt'
%  'tfstr'
%  'adv'
%  'addcapt'
%  'unc'
%  'uncx'
%  'cont'
%  'tfstr'

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

g=varargin{1};

if isnumeric(g)
    g=gd(g);
end

for i = 2:2:length(varargin)
   strin=varargin{i};
   switch strin
      case 'x'
         g.x=varargin{i+1};
         g.x=g.x(:);
         g.type=2;
      case 'y'
         g.y=varargin{i+1};
         g.y=g.y(:);
         g.n=length(g.y);
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
      case 'addcapt'
         g.capt=[varargin{i+1} ' ' g.capt];
      case 'cont'
         g.cont=varargin{i+1};
      case 'unc'
         g.unc=varargin{i+1};
      case 'uncx'
         g.uncx=varargin{i+1};
      case 'tfstr'
         g.tfstr=varargin{i+1};
      case 'adv'
         g.adv=varargin{i+1};
   end
end

% display(g);