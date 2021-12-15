function g=gd_ramp(varargin)
%GD_RAMP  ramp or "pieces" signal
%
% The function is based on the two arrays absc and amp, of dimension nramp+1,
% that describe the "pieces" (or "ramps") function.
% Always absc(1)=1; so y(1)=amp(1), then it is incremented linearly until absc(2),
% for which y(absc(2))=amp(2), and so on.
%
%  keys:
%   'absc'    abscissas of ramp's cusps (in units of dt - natural numbers)
%   'amp'     amplitudes
%   'len'     length (number of values)
%   'dt'      sampling time

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
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

for i = 1:n-1
   dabsc=absc(i+1)-absc(i);
   damp=(amp(i+1)-amp(i))/dabsc;
   for j = 0:dabsc-1
      y(absc(i)+j)=amp(i)+damp*j;
   end
end

y(absc(n))=amp(n);

g=gd(y);

g=edit_gd(g,'capt','ramps','dx',dt);