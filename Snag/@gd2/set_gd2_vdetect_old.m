function g=set_gd2_vdetect(g,long,lat,coord)
%SET_GD2_VDETECT   sets the auxiliary variables for detector velocity (SFDB)
%
%       g=set_gd2_vdetect(g,long,lat,coord)
%
%    g           the gd2
%    long,lat    detectors Earth's coordinates (degrees)
%    coord       type of output coordinates; = 0 -> equatorial, 1 -> ecliptic
%
%  The variables set are g.va, g.vd, g.ve


% Version 1.0 - September 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

rad2deg=180/pi;

t=x_gd2(g);
n=length(t);

va=zeros(n,1);
vd=va;
ve=va;

for i = 1:n
   [va(i),vd(i),ve(i)]=earth_v1(t(i),long,lat,coord);
end

g.va=va*rad2deg;
g.vd=vd*rad2deg;
g.ve=ve;