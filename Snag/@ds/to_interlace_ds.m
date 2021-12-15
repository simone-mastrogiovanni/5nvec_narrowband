function dout=to_interlace_ds(din)
%DS/TO_INTERLACE_DS  from a non-interlaced to an interlaced ds
%
% if din is interlaced -> error

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
   dout.type=2;
   dout.dt=dt;
   y=y_ds(din);
   dout.tini1=din.tini1-dt*len4;
   dout.nc1=1
   dout.y1(len4+1:len)=y(1:3*len4);
   dout.y2(1:3*len4)=y(len4+1:len);
   dout.cont=1;
else
   if dout.cont == 1
      y=y_ds(din);
      dout.tini2=din.tini2-3*len4*dt;
      dout.nc2=dout.lcw+1;
      dout.y2(3*len4+1:len)=y(1:len4);
      dout.y1(1:len4)=y(3*len4+1:len);
      dout.cont=2;
   else
      dout.tini1=din.tini2-len4*dt;
      dout.nc1=dout.lcw+1;
      dout.y1(len4+1:len)=y(1:3*len4);
      dout.y2(1:3*len4)=y(len4+1:len);
      dout.cont=1;
   end
end

dout.lcw=dout.lcw+1;
