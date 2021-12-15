function dop=gw_Doppler(antenna,source,t)
%GW_DOPPLER  computes the percentage Doppler shift for the Earth motion
%
%   antenna,source   pss structures
%     t    TAI (in mjd days)
%
%   *** PROVVISORIA - controllare se e' meglio TAI o UTC ***

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

deg_to_rad=pi/180;

[ae,de,v]=earth_v1(t,antenna.long,antenna.lat,source.coord);

as=source.a*deg_to_rad;
ds=source.d*deg_to_rad;

cosfi=(cos(as)*cos(ae)+sin(as)*sin(ae))*cos(ds)*cos(de)+sin(ds)*sin(de);

dop=1+cosfi*v;
