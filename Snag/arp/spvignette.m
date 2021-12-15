function vout=spvignette(vin,perc,typ)
%SPVIGNETTE  vignette a double array containing an fft or a spectrum
%
%   vin    the input array
%   perc   percentage of vignette
%   type   type: 'cosi', 'ramp'
%   vout   vignetted array

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

l=length(vin);
l1=l*perc;
l2=l/2;
vout=vin;

if typ == 'ramp'
   for i = 2:l1
      vig=(i-1)/l1;
      vout(i)=vin(i)*vig;
      vout(l+2-i)=vin(l+2-i)*vig;
      vout(l2+i)=vin(l2+i)*vig;
      vout(l2+2-i)=vin(l2+2-i)*vig;
   end
else
   for i = 2:l1
      vig=(1-cos(pi*(i-1)/l1))/2;
      vout(i)=vin(i)*vig;
      vout(l+2-i)=vin(l+2-i)*vig;
      vout(l2+i)=vin(l2+i)*vig;
      vout(l2+2-i)=vin(l2+2-i)*vig;
   end
end

vout(1)=0;
vout(l2+1)=0;