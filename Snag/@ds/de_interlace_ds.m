function dout=de_interlace_ds(din)
%DS/de_INTERLACE_DS  from an interlaced to a non-interlaced ds
%
% if din not interlaced -> error

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=din.len;
dt=din.dt;

len2=len/2;
len4=len/4;

if dout.lcw == 0
   din=reset_ds(din);
   dout=ds(len);
   dout.type=1;
   dout.dt=dt;
else
   dout.y2=dout.y1(1:d.len);
end

y=y_ds(din);
dout.tini1=din.tini1+len4*dt;
dout.y1(1:len2)=y(len4+1:3*len4);
y=y_ds(din);
dout.y1(len2+1:len)=y(len4+1:3*len4);
dout.lcw=dout.lcw+1;
dout.nc1=dout=lcw;

   