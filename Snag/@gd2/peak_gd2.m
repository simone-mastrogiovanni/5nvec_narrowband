function gy=peak_gd2(gx,thresh)
%PEAK_GD2  searchs relative maxima over a given threshold in the second dimension
%
%        gy=peak_gd2(gx,thresh)
%
%        gy      output
%        gx      input
%        thresh  threshold

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=y_gd2(gx);
gy=gx;
y=x;

[nspect,nfr]=size(x);
   
for i=1:nspect
   xx=x(i,:);
   x1=rota(xx,1);
   x2=rota(xx,-1);
   for j = 1:nfr
      if y(i,j) > thresh
         if xx(j) > x1(j) & xx(j) > x2(j)
            y(i,j)=xx(j);
         else
            y(i,j)=0;
         end
      else
         y(i,j)=0;
      end
   end
end

gy.y=y;