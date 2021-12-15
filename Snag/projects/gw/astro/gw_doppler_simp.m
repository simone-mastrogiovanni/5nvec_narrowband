function dop=gw_doppler_simp(source,antenna,t)
%GW_DOPPLER  computes the percentage Doppler shift for the Earth motion - simplified version
%            it works with a single time or with a single source
%                   - only for check purpose - use gw_doppler -
%
%         dop=gw_doppler_simp(source,antenna,t)
%
%     source    pss structures or a double array (n*2) with 
%                first col    the sources alpha (in deg)
%                second col   the source delta (in deg)
%
%     antenna   pss structures or detector [lat long] (in deg)
%
%     t         time array (in mjd days)

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg_to_rad=pi/180;

if isstruct(source)
	as=source.a*deg_to_rad;
	ds=source.d*deg_to_rad;
else
    as=source(:,1)*deg_to_rad;
    ds=source(:,2)*deg_to_rad;
end

if isstruct(antenna)
	lat=antenna.lat;
	long=antenna.long;
else
    lat=antenna(1);
    long=antenna(2);
end

xs=cos(ds).*cos(as);
ys=cos(ds).*sin(as);
zs=sin(ds);

[alf,delt,v]=earth_v1(t,long,lat,0);
x=v.*cos(delt).*cos(alf);
y=v.*cos(delt).*sin(alf);
z=v.*sin(delt);

vcosfi=x*xs+y*ys+z*zs;

dop=1+vcosfi;