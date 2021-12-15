function y=dyn_compr_2d(x,scale,type)
%DYN_COMPR_2D   dynamics compression
%
%        y=dyn_compr_gd2(x,scale,type)
%
%        y       output
%        x       input
%        scale   scale
%        type    = 1   atan
%          "     = 2   atan(atan)
%          "     = 3   x for -scale<x<scale, scale for x>scale, -scale for x<-scale

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

y=x;

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
