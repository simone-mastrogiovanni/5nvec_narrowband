function [fr1,a,d,v]=vdoppler(time,fr0,alpha,delta,long,lat,coord,algo)
%VDOPPLER  computes the Doppler shifted frequency and the v vector (vectorial)
%
%        [fr1,a,d,v]=vdoppler(time,fr0,alpha,delta,long,lat,algo)
%
%   fr1            shifted frequencies
%   a,d,v          detector velocity in celestial coordinates (rad)
%   time           serial date-times
%   fr0            original frequencies
%   alpha,delta    source coordinates (in degrees, the type defined by coord)
%   long,lat       detectors Earth's coordinates (degrees)
%   coord          = 0 -> equatorial, = 1 -> ecliptic
%   algo           = 0 rough computation, 1 enhanced, 2 jpl

deg_to_rad=pi/180;

switch algo
    case 0
        [a,d,v]=earth_v1(time,long,lat,coord);
    otherwise
        disp(' *** Not available');
end

as=alpha*deg_to_rad;
ds=delta*deg_to_rad;

cosfi=(cos(as).*cos(a)+sin(as).*sin(a)).*cos(ds).*cos(d)+sin(ds).*sin(d);

fr1=fr0.*(1+cosfi.*v);

