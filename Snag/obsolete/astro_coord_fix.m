function [ao,do]=astro_coord_fix(cin,cout,ai,di)
%ASTRO_COORD_fix   fixed astronomical coordinate conversion, from cin to cout
%                  equatorial, ecliptical, galactic
%
%      [ao,do]=astro_coord_fix(cin,cout,ai,di)
%
%  Angles are in degrees. 
%  cin and cout can be
%
%    'equ'      celestial equatorial: right ascension, declination
%    'ecl'      ecliptical: longitude, latitude
%    'gal'      galactic longitude, latitude
%
%    ai,di      input coordinates
%
%    ao,do      output coordinates
%

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch cin
    case 'equ'
        InCooType='j2000.0';
    case 'ecl'
        InCooType='e';
    case 'gal'
        InCooType='g';
end

switch cout
    case 'equ'
        OutCooType='j2000.0';
    case 'ecl'
        OutCooType='e';
    case 'gal'
        OutCooType='g';
end

InList(:,1)=ai;
InList(:,2)=di;

OutList=coco(InList,InCooType,OutCooType,'d','d');

ao=OutList(:,1);
do=OutList(:,2);