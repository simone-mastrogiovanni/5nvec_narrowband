function fr1=doppler(time,fr0,alpha,delta,long,lat,coord)
%DOPPLER  computes the Doppler shifted frequency 
%
%        fr1=doppler(time,fr0,alpha,delta,long,lat,coord)
%
%   time           serial date-time (mjd; array)
%   fr0            original frequency
%   alpha,delta    source coordinates (in degrees, the type defined by coord)
%   long,lat       detectors Earth's coordinates (degrees)
%   coord          = 0 -> equatorial, = 1 -> ecliptic

deg_to_rad=pi/180;

if ~exist('coord','var')
    coord=0;
end

if coord == 1
    [alpha,delta]=astro_coord('ecl','equ',alpha,delta);
end

[ae,de,v]=earth_v2(time,long,lat);

as=alpha*deg_to_rad;
ds=delta*deg_to_rad;

cosfi=(cos(as).*cos(ae)+sin(as).*sin(ae)).*cos(ds).*cos(de)+sin(ds).*sin(de);

fr1=fr0*(1+cosfi.*v);

