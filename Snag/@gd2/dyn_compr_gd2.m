function gy=dyn_compr_gd2(gx,scale,type)
%DYN_COMPR_GD2   dynamics compression
%
%        gy=dyn_compr_gd2(gx,scale,type)
%
%        gy      output
%        gx      input
%        scale   scale
%        type    = 1   atan
%          "     = 2   atan(atan)
%          "     = 3   x for -scale<x<scale, scale for x>scale, -scale for x<-scale

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=y_gd2(gx);
gy=gx;

switch type
case 1
   y=scale*atan(x/scale);
case 2
   y=scale*atan(atan(x/scale));
case 3
   [n1,n2]=size(x);
   for i=1:n1
   for j=1:n2
      y(i,j)=x(i,j);
      if x(i,j) < -scale
         y(i,j)=-scale;
      end
      if x(i,j) > scale
         y(i,j)=scale;
      end
   end
   end
end

gy.y=y;