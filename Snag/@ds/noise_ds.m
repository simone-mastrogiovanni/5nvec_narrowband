function [d,buff]=noise_ds(d,buff,varargin)
%NOISE_DS  generates a non-interlaced data-stream of noise (ds type 1)
%          using cosine tapered method
%
% This is a ds server.
% The first argument, d, contains a ds.
% The second argument, buff, contains a double array of length 5*d.len/2,
% where:
%   first len data contain the last part of input noise, 
%   the following len/2 the last part of the previous super-chunk,
%   then the following len/2 the tapering for the previous piece;
%   then the final len/2 data  the tapering for the new piece.
% It must be also in output.
% Typical call:
%    [d,buff]=ds_noise(d,buff,'spect',sp,'real')
%
% keys:
%
%   'srspect'      a double containing the sqrt of a (full) spectrum of
%                  length 2*d.len
%   'spect'        a double or gd containing a (full) spectrum of length 2*d.len
% %   'resonances'   a structure for resonances
% %                  the array structure is:
% %                    rs(i).amp
% %                    rs(i).freq
% %                    rs(i).tau
%   'complex'      complex output (at the end)

% Operation:
%
% if d.lcw == 0 -> initializes
% if d.lcw ~= d.lcr exits
% if d.lcw < d.lcr  error
% if d.lcw > d.lcr  warning
%
%                         Procedure
%
% At every call a chunk of length len is produced. It is the central part
% of a super-chunk produced by a 2*len chunk of white noise, frequency filtered,
% and then composed with the last fourth of the preceding chunk.
% The composition is done with a cosine window. 
% At each call we need the last half of the white noise used in the
% preceding super-chunk and the last fourth of the preceding super-chunk.
% We keep also the cosine window for reducing the computing.

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
       sp=varargin{i+1};
       if isa(sp,'gd')
           sp=y_gd(sp);
       end
      sp=sqrt(sp/d.dt)/1.125;  % 1.125 empirical factor
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
lfft=2*len;
len2=len/2;

if d.lcw == 0   
   d.ind1=1; d.cont=0;
   d.tini1=d.treq-len*d.dt;
%   d.type=1;  grosso errore presumibile
   d.capt='noise simulation';
   if d.type == 2
       error(' *** Interlaced DS !')
   end
   x=randn(1,lfft);
   if icsp == 1
      sp=sp(:)';
      b1=fft(x); % size(b1),size(sp),lfft
      b1=b1.*sp;
      b1=ifft(b1);
      buff(1:len)=x(len+1:lfft);
      buff(len+1:len+len2)=b1(len+len2+1:lfft);
      buff(lfft+1:lfft+len2)=-(cos((1:len2)*pi/len2)-1)/2;
      buff(len+len2+1:lfft)=sqrt(1-buff(lfft+1:lfft+len2).^2);
      %figure,plot(buff(len+len2+1:lfft)),hold on,plot(buff(lfft+1:lfft+len2))
      d.y1=b1(len2+1:len2+len);
   end
else
    if d.type == 1
        d.y2=d.y1(1:d.len);
    end
    if icsp == 1
       sp=sp(:)';
       x(1:len)=buff(1:len);
       x(len+1:lfft)=randn(1,len);
       b1=fft(x);
       b1=b1.*sp;
       b1=ifft(b1);
       d.y1(1:len2)=buff(len+1:len+len2).*buff(len+len2+1:lfft)+...
          b1(len2+1:len).*buff(lfft+1:lfft+len2);
       d.y1(len2+1:len)=b1(len+1:len+len2);
%       d.y1=b1(len2+1:len+len2);
        
       buff(1:len)=x(len+1:lfft);
       buff(len+1:len+len2)=b1(len+len2+1:lfft);
    end
end


d.tini1=d.tini1+len*d.dt;
d.lcw=d.lcw+1;
d.nc1=d.lcw;
lcw=sprintf('%d',d.lcw);
%disp(strcat('ds chunk ->',lcw,' - y1'));
