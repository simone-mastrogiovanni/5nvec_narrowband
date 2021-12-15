function gd_play(varargin)
%GD_PLAY  plays a gd
%
% the first argument is the gd
%
%  keys :
%
%   'freq'   followed by the sampling frequency
%   'deff'   sampling frequency at 8192 Hz
%
%   nokey    uses the gd sampling time (in Hz)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gin=varargin{1};
freq=1/dx_gd(gin);
y=y_gd(gin);

for i = 2:length(varargin)
   str=varargin{i};
   switch str
   case 'freq'
      freq=varargin{i+1};
   case 'deff'
      freq=8192;
   end
end

sound(y,freq);