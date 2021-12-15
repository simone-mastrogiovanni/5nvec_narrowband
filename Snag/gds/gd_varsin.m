function g=gd_varsin(varargin)
%GD_VARSIN  sinusoidal signal
%
%  keys:
%   'amp'       amplitude, followed by the ini and fin amp
%   'freq'      frequency, followed by the ini and fin freq
%   'phase'     phase, followed by the ini and fin phase (in degrees)
%   'len'       length (number of values)
%   'dt'        sampling time

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

iniamp=1;
inifreq=0.1;
iniphase=0;
finamp=1;
finfreq=0.1;
finphase=0;
len=1000;
dt=1;

for i = 1:length(varargin)
   str=varargin{i};
   switch str
   case 'amp'
      iniamp=varargin{i+1};
      finamp=varargin{i+2};
   case 'freq'
      inifreq=varargin{i+1};
      finfreq=varargin{i+2};
   case 'phase'
      iniphase=varargin{i+1};
      finphase=varargin{i+2};
   case 'len'
      len=varargin{i+1};
   case 'dt'
      dt=varargin{i+1};
   end
end

i=0:(len-1);
y=i*dt;

damp=(finamp-iniamp)/(len-1);
dfr=(finfreq-inifreq)/(len-1);
dph=(finphase-iniphase)/(len-1);

amp=iniamp+damp*i;
om=2*pi*(inifreq+dfr*i);
ph=(iniphase+dph*i)*pi/180;

ph=cumsum(om.*dt)+ph;

y=amp.*sin(ph);

g=gd(y);

g=edit_gd(g,'capt','varsin','dx',dt);