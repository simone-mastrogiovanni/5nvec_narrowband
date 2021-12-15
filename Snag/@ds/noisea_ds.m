function [d,buff]=noisea_ds(d,buff,varargin)
%NOISEA_DS  generates a non-interlaced data-stream of noise (ds type 1)
%           using interlaced input noise method
%
% This is a ds server
% the first arguments contains a ds
% the second argument, buff, contains a double array of length 3*d.len/2; 
%   it must be also in output.
% Typical call:
%    [d,buff]=ds_noise(d,buff,'spect',sp,'real')
%
% keys:
%
%   'spect'        a double containing a spectrum
%   'resonances'   a structure for resonances
%                  the array structure is:
%                    rs(i).amp
%                    rs(i).freq
%                    rs(i).tau
%   'complex'      complex output (at the end)

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

icsp=0;
nrs=0;
icreal=1;

for i = 1:2:length(varargin)
	str=varargin{i};
   switch str
   case 'spect'
      sp=varargin{i+1};
      icsp=1;
   case 'resonances'
      rs=varargin{i+1};
      nrs=length(rs);
   case 'ramp'
      d.cont=1;
   case 'complex'
      icreal=0;
   end
end

len=d.len;
len2=len/2;
len4=len/4;

if d.lcw == 0   
   d.ind1=1;
   d.tini1=d.treq-len*d.dt;
%   d.type=1;  grosso errore presumibile
   d.capt='noise simulation';
   buff=randn(1,3*len2);
else
   d.y2=d.y1(1:d.len);
   buff(1:len2)=buff(len+1:3*len2);
   buff(len2+1:3*len2)=randn(1,len);
end

if icsp == 1
   sp=sp(:)';
   b1=buff(1:len);
   %b1=vignette(b1,0.25,'cosi');
   b1=fft(b1);
   b1=b1.*sqrt(sp);
   %b1=spvignette(b1,0.005,'cosi');
   b1=ifft(b1);
   b2=buff(len2+1:3*len2);
   %b2=vignette(b2,0.25,'cosi');
   b2=fft(b2);
   b2=b2.*sqrt(sp);
   %b2=spvignette(b2,0.005,'cosi');
   b2=ifft(b2);
   if icreal == 1
      b1=real(b1);
      b2=real(b2);
   end
end

d.tini1=d.tini1+len*d.dt;
d.y1(1:len2)=b1(len4+1:3*len4);
d.y1(len2+1:len)=b2(len4+1:3*len4);
d.lcw=d.lcw+1;
d.nc1=d.lcw;
lcw=sprintf('%d',d.lcw);
disp(strcat('ds chunk ->',lcw,' - y1'));
