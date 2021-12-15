function d=gd2ds(d,g)
%GD2DS  produces a ds from a (long) gd g
%
%       d=gd2ds(d,g)
%
% the ds d must be pre-created, with its particular features
% the ds is not interlaced

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if d.lcw == 0
   dt=dx_gd(g);
   d.dt=dt;
   d.type=1;
   d.ind1=0;
   d.cont=0;
   d.tini1=ini_gd(g);
else
   d.y2=d.y1(1:d.len);
end

min=d.ind1+1;
max=d.ind1+d.len;
n=n_gd(g);

if max <= n
   d.y1(1:d.len)=y_gd(g,min,max);
   d.ind1=max;
   d.lcw=d.lcw+1;
   d.nc1=d.lcw;
   lcw=sprintf('%d',d.lcw);
   disp(strcat('ds chunk ->',lcw,' - y1'));
else
   if d.cont == 0
      d.y1(1:n-min+1)=y_gd(g,min,n);
      d.ind1=n;
      d.lcw=d.lcw+1;
      d.nc1=d.lcw;
      lcw=sprintf('%d',d.lcw);
      disp(strcat('ds chunk ->',lcw,' - y1'));
      disp('end data');
      d.cont=1;
   else
      disp('no more data !');
   end
end

      