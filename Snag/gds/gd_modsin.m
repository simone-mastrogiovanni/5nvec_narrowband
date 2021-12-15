function g=gd_modsin(varargin)
%GD_MODSIN  modulated sinusoidal signal
%
%  keys:
%   'amp'     amplitude, followed by the amp
%   'freq'    frequency, followed by the freq
%   'phase'   phase, followed by the phase (in degrees)
%   'len'     length (number of values)
%   'dt'      sampling time
%
%   'am_amp'  amplitude modulation amplitude (percentage)
%   'am_fr'        "          "    frequency
%   'fm_amp'  frequency       "    amplitude (percentage)
%   'fm_fr'        "          "    frequency
%   'pm_amp'     phase        "    amplitude
%   'pm_fr'        "          "    frequency

% Version 1.0 - November 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2000  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

amp=1;
freq=0.1;
phase=0;
len=1024;
dt=1;

am_amp=0;
am_fr=0.01;
fm_amp=0.05;
fm_fr=0.01;
pm_amp=0;
pm_fr=0.01;

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
   case 'am_amp'
      am_amp=varargin{i+1};
   case 'am_fr'
      am_fr=varargin{i+1};
   case 'fm_amp'
      fm_amp=varargin{i+1};
   case 'fm_fr'
      fm_fr=varargin{i+1};
   case 'pm_amp'
      pm_amp=varargin{i+1};
   case 'pm_fr'
      pm_fr=varargin{i+1};
   end
end

y=(0:(len-1))*dt;
om=2*pi*freq;
ph=phase*pi/180;

oma=2*pi*am_fr;
omf=2*pi*fm_fr;
omp=2*pi*pm_fr;
amp1=amp*(1+am_amp*sin(oma*y));
dph1=om*(1+fm_amp*sin(omf*y));
ph1=ph+pm_amp*sin(omp*y)+cumsum(dph1)*dt-om*dt;

y=amp1.*sin(ph1);

g=gd(y);

g=edit_gd(g,'capt','modsin','dx',dt);