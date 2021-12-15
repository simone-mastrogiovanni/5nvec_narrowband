function dout=frfilt_ds(din,filt)
%DS/FRFILT_DS  frequency domain filter on interlaced ds
%              produces a not interlaced ds
%
%        dout=frfilt_ds(din,filt)
%
% length(filt) must be a power of 2 and equal to din.len
% dout must be reset

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if dout.lcw == 0
   din=resetds(din);
   dout.type=1;
else
   dout.y2=dout.y1;
   dout.tini2=dout.tini1;
end

dt=din.dt;
len=din.len;
len2=len/2;
len4=len/4;

y=y_ds(din);
y=fft(y);
y=y.*filt;
y=ifft(y);
dout.y1(1:len2)=y(len4+1:3*len4);

y=y_ds(din);
y=fft(y);
y=y.*filt;
y=ifft(y);
dout.y1(len2+1:len)=y(len4+1:3*len4);

dout.lcw=dot.lcw+1;
dout.tini1=din.tini2-len4*dt;