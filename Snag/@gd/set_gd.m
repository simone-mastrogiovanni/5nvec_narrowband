function g=set_gd(varargin)
%GD/SET_GD  sets a gd already existing
%
% use always with ; and the output gd
% the first input argument must be the gd to set
%
% keys :
%   parameters:
%     'x'
%     'y'
%     'n'
%     'type'
%     'ini'
%     'dx'
%     'capt'
%   functions and arguments:
%        'amplitude'
%     'sin'
%        'period'
%        'phase'
%     'exp'
%        'frequency'
%        'phase'
%        'tau' (positive for dumping)
%     'gauss'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

for i = 2:length(varargin)
   strin=varargin{i};
   switch strin
      case 'x'
         g.x=varargin{i+1};
         g.x=g.x(:);
      case 'y'
         g.y=varargin{i+1};
         g.y=g.y(:);
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
   end
end

x=x_gd(g);

amp=1;
per=123;
fr=0;
ph=0;
tau=Inf;

for i = 2:length(varargin)
   strin=varargin{i};
   switch strin
   	case 'amplitude'
      	amp=varargin{i+1};
      case 'period'
         per=varargin{i+1};
      case 'frequency'
         fr=varargin{i+1};
      case 'phase'
         ph=varargin{i+1};
      case 'tau'
         tau=varargin{i+1};
   end
end

pi2=2*pi;

for i = 2:length(varargin)
   strin=varargin{i};
   switch strin
   	case 'sin'
         g.y=amp.*sin(x*pi2/per+ph);
         g.y=g.y(:);
         g.capt='sin';
      case 'exp'
         if fr ~= 0
            arg=j*fr*pi-1/tau;
            camp=amp*exp(j*ph);
            g.y=camp*exp(arg.*x);
            g.y=g.y(:);
         else
            g.y=amp*exp(-x./tau);
            g.y=g.y(:);
         end
         g.capt='exp';
      case 'gauss'
         g.y=randn(size(x));
         g.y=g.y(:);
         g.capt='gauss';
   end
end

% display(g);