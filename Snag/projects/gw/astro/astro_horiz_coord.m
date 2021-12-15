function [ao,do]=astro_horiz_coord(dir,ai,di,long,lat,mjd)
%ASTRO_HORIZ_COORD  equatorial to and from horizontal coordinates
%
%    [ao,do]=astro_horiz_coord(dir,ai,d1,long,lat,mjd)
%
%   dir       'h' or 'e': to horizontal or equatorial
%   ai,di     input coordinates (azimuth is from S to W)
%   long,lat  longitude (eastward) and latitude
%   mjd       modified julian date
%
%   ao,do     output coordinates

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

deg2rad=pi/180;

InCoo(:,1)=ai*deg2rad;
InCoo(:,2)=di*deg2rad;
JD=mjd+2400000.5;
TopoPos(:,1)=long*deg2rad;
TopoPos(:,2)=lat*deg2rad;

OutCoo=horiz_coo(InCoo,JD,TopoPos,dir);

ao=OutCoo(:,1)/deg2rad-180;
do=OutCoo(:,2)/deg2rad;