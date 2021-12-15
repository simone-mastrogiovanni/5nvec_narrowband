function [d,buff]=noise_ds(d,buff,varargin)
%NOISE_DS  generates a non-interlaced data-stream of noise (ds type 1)
%          using cosine tapered method
%
% This is a ds server
% the first argument, d, contains a ds
% the second argument, buff, contains a double array of length 3*d.len/2, 
%   which first third contains the input noise, the second third the
%   output noise (of the previous stage), the third third the cosine window;
%   it must be also in output.
% Typical call:
%    [d,buff]=ds_noise(d,buff,'spect',sp,'real')
%
% keys:
%
%   'srspect'      a double containing the sqrt of a spectrum
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

% Version 1.0 - June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icsp=0;
nrs=0;
icreal=1;

for i = 1:2:length(varargin)
	str=varargin{i};
   switch str
   case 'srspect'
      sp=varargin{i+1};
      icsp=1;
   case 'spect'
      sp=sqrt(varargin{i+1});
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
   x=randn(1,len);
   if icsp == 1
      sp=sp(:)';
      b1=fft(x);
      b1=b1.*sp;
      b1=ifft(b1);
      buff(1:len2)=x(len2+1:len);
      buff(len2+1:len)=b1(len2+1:len);
      buff(len+1:len+len2)=cos((0:len2-1)*pi/len);
   end
else
   d.y2=d.y1(1:d.len);
end

if icsp == 1
   sp=sp(:)';
   x(1:len2)=buff(1:len2);
   x(len2+1:len)=randn(1,len2);
   b1=fft(x);
   b1=b1.*sp;
   b1=ifft(b1);
   d.y1(1:len2)=buff(len2+1:len).*buff(len+1:len2+len)+...
      b1(1:len2).*(1-buff(len+1:len2+len).^2);
   
   x(1:len2)=x(1+len2:len);
   x(len2+1:len)=randn(1,len2);
   b2=fft(x);
   b2=b2.*sp;
   b2=ifft(b2);
   d.y1(1:len2)=b1(len2+1:len).*buff(len+1:len2+len)+...
      b2(1:len2).*(1-buff(len+1:len2+len).^2);
   
   buff(1:len2)=x(len2+1:len);
   buff(len2+1:len)=b2(len2+1:len);
end

d.tini1=d.tini1+len*d.dt;
d.y1(1:len2)=b1(len4+1:3*len4);
d.y1(len2+1:len)=b2(len4+1:3*len4);
d.lcw=d.lcw+1;
d.nc1=d.lcw;
lcw=sprintf('%d',d.lcw);
%disp(strcat('ds chunk ->',lcw,' - y1'));
