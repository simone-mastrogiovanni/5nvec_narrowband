function [ao do]=astro_coord_ofek(cin,cout,ai,di)

%      [ao,do]=astro_coord_ofek(cin,cout,ai,di)
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
%
%    ao,do      output coordinates


InList(:,1)=ai;
InList(:,2)=di;

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

InUnits='d';
OutUnits='d';

[OutList,TotRot]=coco(InList,InCooType,OutCooType,InUnits,OutUnits);

ao=OutList(:,1);
do=OutList(:,2);