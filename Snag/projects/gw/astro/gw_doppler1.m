function dop=gw_doppler1(v,source)
%GW_DOPPLER1  computes the percentage Doppler shift for the Earth motion
%            it works given the detector velocity vector
%
%     v         detector 3-D vector velocity
%     source    pss source structure 
%

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg_to_rad=pi/180;

as=source.a*deg_to_rad;
ds=source.d*deg_to_rad;

xs=cos(ds).*cos(as);
ys=cos(ds).*sin(as);
zs=sin(ds);

vcosfi=v(:,1)*xs+v(:,2)*ys+v(:,3)*zs;

dop=1+vcosfi;
