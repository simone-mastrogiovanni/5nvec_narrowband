function ind=indsel(xmin,dx,nmax,x1)
%INDSEL     ind=indsel(xmin,dx,nmax,x1)
% determines the index of x=xmin+(ind-1)*dx nearest to x1
%          if nmax > 0, nmax is the maximum possible value 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ind=floor((x1-xmin)/dx+1.5);
if ind < 1 
   ind=1;
end
if nmax > 0
   if ind > nmax
      ind=nmax;
   end
end

