function d=signal_ds(varargin)
%DS/SIGNAL_DS  generates a data-stream of signals
%
% This is a ds server
% the first arguments contains a ds
%
% keys:
%
%   'constant'     a constant equal to amplitude
%   'whitenoise'   white noise
%   'sin'          a sinusoid                
%   'ramp'         a ramp in output
%   'amplitude'    with a number
%   'frequency'         "
%   'period'            "
%   'phase'             "

% Operation:
%
% if d.lcw == 0 -> initializes
% if d.lcw ~= d.lcr exits
% if d.lcw < d.lcr  error
% if d.lcw > d.lcr  warning

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


d=varargin{1};

icsig=0;
amp=1;
fr=1;
per=1;
ph=0;

for i = 2:length(varargin)
	str=varargin{i};
   switch str
   case 'whitenoise'
      icsig=1;
   case 'sin'
      icsig=2;
   case 'ramp'
      icsig=3;
   case 'amplitude'
      amp=varargin{i+1};
   case 'frequency'
      fr=varargin{i+1};
   case 'period'
      per=varargin{i+1};
      fr=1/per;
   case 'phase'
      ph=varargin{i+1};
   end
end

pi2=2*pi;
om=fr*pi2;

len=d.len;
len2=len/2;

ic=1;

if d.lcw == 0   
   d.ind1=1;
   d.tini1=d.treq-len*d.dt;
   if d.type == 2
      d.ind1=len/4+1;
      d.tini2=d.tini1+len2*d.dt;
   end
   d.ind2=1;
   d.capt='noise simulation';
else
   if d.type == 2
      if d.lcw == d.nc1
         ic=2;
      end
   end

   if d.type == 1
      d.y2=d.y1(1:d.len);
      d.tini2=d.tini1;
   end
end

if ic == 1
   d.tini1=d.tini1+len*d.dt;
   if icsig == 0
      d.y1(d.ind1:len)=amp;
   elseif icsig == 1
      d.y1(d.ind1:len)=randn(1,len-d.ind1+1).*amp;
   elseif icsig == 2
      arg=((d.ind1:len).*d.dt+d.tini1).*om+ph;
      arg=mod(arg,pi2);
      d.y1(d.ind1:len)=sin(arg).*amp;
   elseif icsig == 3
      d.y1(d.ind1:len)=((d.ind1:len).*d.dt+d.tini1).*amp;
   end
   d.ind1=1;
   if d.type == 2
      d.y2(d.ind2:len2)=d.y1(len2+1:len);
      d.ind2=len2+1;
   end
   d.lcw=d.lcw+1;
   d.nc1=d.lcw;
   lcw=sprintf('%d',d.lcw);
   disp(strcat('ds chunk ->',lcw,' - y1'));
else
   d.tini2=d.tini2+len*d.dt;
   if icsig == 0
      d.y2(d.ind2:len)=amp;
   elseif icsig == 1
      d.y2(d.ind2:len)=randn(1,len2).*amp;
   elseif icsig == 2
      arg=((d.ind2:len).*d.dt+d.tini2).*om+ph;
      arg=mod(arg,pi2);
      d.y2(d.ind2:len)=sin(arg).*amp;
   elseif icsig == 3
      d.y2(d.ind2:len)=((d.ind2:len).*d.dt+d.tini2).*amp;
   end
   d.ind2=1;
   d.y1(d.ind1:len2)=d.y2(len2+1:len);
   d.ind1=len2+1;
   d.lcw=d.lcw+1;
   d.nc2=d.lcw;
   lcw=sprintf('%d',d.lcw);
   disp(strcat('ds chunk ->',lcw,' - y2'));
end
