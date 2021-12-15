function g=gd_step(varargin)
%GD_STEP  step signal
%
%  keys:
%   'absc'    abscissas of deltas (in units of dt - natural numbers)
%   'amp'     amplitudes
%   'len'     length (number of values)
%   'dt'      sampling time

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

coef=[0 0 1];
len=1000;
dt=1;

for i = 1:2:length(varargin)
   str=varargin{i};
   switch str
   case 'absc'
      absc=varargin{i+1};
   case 'amp'
      amp=varargin{i+1};
   case 'len'
      len=varargin{i+1};
   case 'dt'
      dt=varargin{i+1};
   end
end

n=length(absc);

y=zeros(1,len);

for i=1:n
   y(absc(i))=amp(i);
end

y=cumsum(y);

g=gd(y);

g=edit_gd(g,'capt','deltas','dx',dt);