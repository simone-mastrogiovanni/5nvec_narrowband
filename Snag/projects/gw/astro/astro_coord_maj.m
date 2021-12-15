function [ao,do]=astro_coord(cin,cout,ai,di)
%ASTRO_COORD   astronomical coordinate conversion, from cin to cout
%
%      [ao,do]=astro_coord(conv,ai,di)
%
%  Angles and tsid are in radiants. Local tsid and latitude is needed
%  for conversions to and from the horizon coordinates.
%  cin and cout can be
%
%    'horizontal'     azimuth, altitude
%    'equatorial'     celestial equatorial: right ascension, declination
%    'ecliptical'     ecliptical: longitude, latitude
%    'galactic'       galactic longitude, latitude
%
%  epsilon = 23.4392911 deg is the aberration to right asc. and declination
%  if they are referred to the standard equinox of year 2000.
%  (epsilon = 23.4457889 deg, if they are referred to the standard equinox of 
%  year 1950.)

% Version 1.0 - June 1999
% Copyright (C) 1999-2000  Ettore Majorana - ettore.majorana@roma1.infn.it
% Istituto Nazionale di Fisica Nucleare Sez. di Roma 
% c/o Universita` "La Sapienza"
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome



deg2rad=pi /180;
rad2deg=180/pi ;
rad2h  =12 /pi ;
h2rad  =pi /12 ;
epsilon = 23.4392911 *deg2rad;   
flagin =strcmp(cin,'equatorial');
flagout=strcmp(cout,'equatorial');

if flagin == 0
   switch cin
   case 'horizontal'
%      ae=...;
%      de=...;
   case 'ecliptical'
		ae=atan((sin(ai*deg2rad) *cos(epsilon) + tan(di*deg2rad)*sin(epsilon))/cos(ai*deg2rad)) *rad2h;
		de=asin(sin(di*deg2rad) *cos(epsilon) -cos(di*deg2rad) *sin(epsilon) *sin(ai*deg2rad))  *rad2deg; 
   case 'galactic'
   end
else
   ae=ai;
   de=di;
end

if flagout == 0
   switch cout
   case 'horizontal'
   %   ao=...;
   %   do=...;
	case 'ecliptical'
		ao=atan((sin(ai*h2rad) *cos(epsilon) - tan(di*deg2rad)*sin(epsilon))/cos(ai*h2rad)) *rad2h;
		do=asin(sin(di*h2rad) *cos(epsilon) +cos(di*deg2rad) *sin(epsilon) *sin(ai*h2rad))  *rad2deg; 
   case 'galactic'
   end
else
   ao=ae;
   do=de;
end
