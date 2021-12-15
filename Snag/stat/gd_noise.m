function g=gd_noise(varargin)
%GD_NOISE   random signals
%
%  keys:
%   'amp'     amplitude, followed by the amp
%   'len'     length (number of values)
%   'dt'      sampling time
%   'gauss'   gaussian
%   'exp'     exponential
%   'chisq'   chi square, followed by the number of degrees
%   'unif'    uniform
%   'complex' complex

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

amp=1;
len=1000;
dt=1;
type='gaussian noise';
ndeg=0;
set_random;
iccompl=0;

for i = 1:length(varargin)
   str=varargin{i};
   switch str
   case 'amp'
      amp=varargin{i+1};
   case 'len'
      len=varargin{i+1};
   case 'dt'
      dt=varargin{i+1};
   case 'gauss'
      type='gaussian noise';
   case 'exp'
      type='exponential noise';
   case 'chisq'
      type='chi-square noise';
      ndeg=varargin{i+1};
   case 'unif'
      type='uniform noise';
   case 'complex'
       iccompl=1;
   end
end

y=zeros(1,len);

switch type
case 'gaussian noise'
   y=amp*randn(1,len);
   if iccompl == 1
       y=y+j*amp*randn(1,len);
   end
case 'exponential noise'
   y=amp*(randn(1,len).^2+randn(1,len).^2)/2;
   if iccompl == 1
       y=y+j*amp*(randn(1,len).^2+randn(1,len).^2)/2;
   end
case 'chi-square noise'
   for i = 1:ndeg
      y=y+amp*randn(1,len).^2;
   if iccompl == 1
       y=y+j*amp*randn(1,len).^2;
   end
   end
case 'uniform noise'
   y=rand(1,len);
   if iccompl == 1
       y=y+j*amp*rand(1,len);
   end
end

g=gd(y);

g=edit_gd(g,'capt',type,'dx',dt);