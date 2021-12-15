function g=gd_sin(varargin)
%GD_SIN  sinusoidal signal
%
%  keys:
%   'amp'     amplitude, followed by the amp
%   'freq'    frequency, followed by the freq
%   'phase'   phase, followed by the phase (in degrees)
%   'len'     length (number of values)
%   'dt'      sampling time

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

amp=1;
freq=0.1;
phase=0;
len=1000;
dt=1;

for i = 1:length(varargin)
   str=varargin{i};
   switch str
   case 'amp'
      amp=varargin{i+1};
   case 'freq'
      freq=varargin{i+1};
   case 'phase'
      phase=varargin{i+1};
   case 'len'
      len=varargin{i+1};
   case 'dt'
      dt=varargin{i+1};
   end
end

y=(0:(len-1))*dt;
om=2*pi*freq;
ph=phase*pi/180;

y=amp*sin(om*y+ph);

g=gd(y);

g=edit_gd(g,'capt','sin','dx',dt);