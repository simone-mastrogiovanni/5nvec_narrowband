function [L,B,R]=ple_planet(Date,Planet,CooSystem);
%------------------------------------------------------------------------------
% ple_planet function                                                    ephem
% Description: Low accuracy ephemeris for the main planets. Given a
%              planet name calculate its heliocentric coordinates
%              referred to mean ecliptic and equinox of date.
%              Accuarcy: Better ~1' in long/lat, ~0.001 au in dist.
% Input  : - matrix of dates, [D M Y frac_day] per line,
%            or JD per line. In TT time scale.
%          - Planet name:
%            {'Mercury' | 'Venus' | 'Earth' |  'Mars' |
%             'Jupiter' | 'Saturn' | 'Uranus' | 'Neptune'}
%          - Coordinate system:
%            'LBR' : [L, B, R] in (rad, rad, au), default.
%            'XYZ' : [X, Y, Z] in au and ecliptic systems.
% Output : - Heliocentric longitude in radians, or X in au.
%          - Heliocentric latitude in radians, or Y in au. 
%          - Heliocentric radius vector in au, or Z in au.
% Reference: VSOP87
% Tested : Matlab 5.3
%     By : Eran O. Ofek                   October 2001
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
% Reliable: 2
%------------------------------------------------------------------------------
if (nargin==2),
   CooSystem = 'LBR';
elseif (nargin==3),
   % do nothing
else
   error('Illigal number of input arguments');
end


switch Planet
 case 'Mercury'
    [L,B,R]=ple_mercury(Date);
 case 'Venus'
    [L,B,R]=ple_venus(Date);
 case 'Earth'
    [L,B,R]=ple_earth(Date);
 case 'Mars'
    [L,B,R]=ple_mars(Date);
 case 'Jupiter'
    [L,B,R]=ple_jupiter(Date);
 case 'Saturn'
    [L,B,R]=ple_saturn(Date);
 case 'Uranus'
    [L,B,R]=ple_uranus(Date);
 case 'Neptune'
    [L,B,R]=ple_neptune(Date);
 otherwise
    error('Unknown planet option');
end


switch CooSystem
 case 'LBR'
    % already in 'LBR' - do nothing
 case 'XYZ'
    X = R.*cos(L).*cos(B);   % X
    Y = R.*sin(L).*cos(B);   % Y
    Z = R.*sin(B);           % Z
    L = X;
    B = Y;
    R = Z;
 otherwise
    error('Unknown coordinate system');
end
