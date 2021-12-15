function [ao,do]=astro_coord(cin,cout,ai,di,ltsid,lat)
%ASTRO_COORD   astronomical coordinate conversion, from cin to cout
%
%      [ao,do]=astro_coord(cin,cout,ai,di,ltsid,lat)
%
%   See also astro_coord_fix
%
%  Angles are in degrees. Local tsid (in hours) and latitude is needed
%  for conversions to and from the horizon coordinates.
%  cin and cout can be
%
%    'hor'      azimuth, altitude
%    'equ'      celestial equatorial: right ascension, declination
%    'ecl'      ecliptical: longitude, latitude
%    'gal'      galactic longitude, latitude
%
%    ai,di      input coordinates
%    ltsid,lat  local sidereal time and latitude (only for horizontal coordinates)
%
%    ao,do      output coordinates
%
%  epsilon = 23.4392911 deg is the inclination of the Earth orbit on the
%  equatorial plane, referred to the standard equinox of year 2000
%  (epsilon = 23.4457889 deg, for the standard equinox of year 1950).

% Version 2.0 - August 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


deg2rad=pi/180;
rad2deg=180/pi ;
ai=ai*deg2rad;
di=di*deg2rad;

ao=ai;
do=di;

cai=cos(ai);
sai=sin(ai);
cdi=cos(di);
sdi=sin(di);

% ecliptic
eps =23.4392911*deg2rad;
ceps=cos(eps);
seps=sin(eps);

% galactic
gal=62.9*deg2rad;
cgal=cos(gal);
sgal=sin(gal);
galnode=282.85*deg2rad;

switch cin
    case 'hor'
        disp('not yet implemented')
    case 'ecl'
        cdo=sqrt((cdi.*cai).^2+(cdi.*sai.*ceps-sdi.*seps).^2);
        sdo=cdi.*sai.*seps+sdi.*ceps;
        do=atan(sdo./cdo);
        cao=cdi.*cai./cos(do);
        sao=(cdi.*sai.*ceps-sdi.*seps)./cos(do);
        ao=atan2(sao,cao);
    case 'gal'
        disp('not yet implemented')
end

switch cout
    case 'hor'
        disp('not yet implemented')
    case 'ecl'
        cdo=sqrt((cdi.*cai).^2+(cdi.*sai.*ceps+sdi.*seps).^2);
        sdo=-cdi.*sai.*seps+sdi.*ceps;
        do=atan(sdo./cdo);
        cao=cdi.*cai./cos(do);
        sao=(cdi.*sai.*ceps+sdi.*seps)./cos(do);
        ao=atan2(sao,cao);
    case 'gal'
        disp('not yet implemented')
end

ao=ao/deg2rad;
do=do/deg2rad;
if ao < 0
    ao=ao+360;
end
