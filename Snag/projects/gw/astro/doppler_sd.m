function fr1=doppler_sd(time,frsd,alpha,delta,long,lat)
%DOPPLER  computes the Doppler shifted frequency and spin-down
%
%        fr1=doppler(time,frsd,alpha,delta,long,lat)
%
%   time           serial date-time (mjd; array)
%   frsd           [epoch(MJD) frequency spin-down]
%   alpha,delta    source coordinates (in degrees, the type defined by coord)
%   long,lat       detectors Earth's coordinates (degrees)

% Version 2.0 - September 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

deg_to_rad=pi/180;

[ae,de,v]=earth_v2(time,long,lat);

as=alpha*deg_to_rad;
ds=delta*deg_to_rad;

cosfi=(cos(as).*cos(ae)+sin(as).*sin(ae)).*cos(ds).*cos(de)+sin(ds).*sin(de);

T0=frsd(1);
fr0=frsd(2);
sd=frsd(3);
fr=(time-T0)*86400*sd+fr0;
fr=fr(:);
v=v(:);

fr1=fr.*(1+cosfi.*v);

