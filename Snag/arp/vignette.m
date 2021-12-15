function vout=vignette(vin,perc,typ)
%VIGNETTE  vignette a double array containing an fft or a spectrum
%
%         vout=vignette(vin,perc,typ)
%
%   vin    the input array
%   perc   percentage of vignette
%   typ    type: 'cosi', 'ramp'
%   vout   vignetted array

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

l=length(vin);
l1=l*perc;
vout=vin;

if typ == 'ramp'
   for i = 1:l1
      vig=(i-1)/l1;
      vout(i)=vin(i)*vig;
      vout(l+1-i)=vin(l+1-i)*vig;
   end
else
   for i = 1:l1
      vig=(1-cos(pi*(i-1)/l1))/2;
      vout(i)=vin(i)*vig;
      vout(l+1-i)=vin(l+1-i)*vig;
   end
end

vout(1)=0;
vout(len)=0;