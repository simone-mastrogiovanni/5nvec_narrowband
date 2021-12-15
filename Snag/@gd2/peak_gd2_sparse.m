function gy=peak_gd2_sparse(gx,thresh)
%PEAK_GD2_SPARSE  searchs relative maxima over a given threshold in the second dimension
%
%        gy=peak_gd2_sparse(gx,thresh)
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

[nspect,nfr]=size(x);
npeaktot=0
   
for i=1:nspect
   y=x(i,:);
   y1=rota(y,1);
   y2=rota(y,-1);
   y1=ceil(sign(y-y1)/2);
   y2=ceil(sign(y-y2)/2);
   y1=y1.*y2;
   y=y.*y1;
   y2=ceil(sign(y-thresh)/2);
   y=y.*y2;
   npeak=sum(y2);
   [i1,j1,s1]=find(y);
   i2(npeaktot+1:npeaktot+npeak)=j1;
   j2(npeaktot+1:npeaktot+npeak)=i;
   s2(npeaktot+1:npeaktot+npeak)=s1;
   npeaktot=npeaktot+npeak;
end

A=sparse(i2,j2,s2,nfr,nspect);
spy(A);
gy.y=A';