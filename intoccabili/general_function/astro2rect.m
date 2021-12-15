function r=astro2rect(a,icrad)
% ASTRO2RECT  conversion from stronomical to rectangular coordinates
%
%   a         astronomical coordinates [ra dec module]
%             if a = [ra dec] is converted to [ra dec 1]
%   icrad     0 = degrees (default), 1 = radiants

if length(a) == 2
    a=[a(:)' 1];
end

if ~exist('icrad','var')
    icrad=0;
end

if icrad == 0
    deg2rad=pi/180;
    a(1)=a(1)*deg2rad;
    a(2)=a(2)*deg2rad;
end

r(1)=cos(a(1)).*cos(a(2)).*a(3);
r(2)=sin(a(1)).*cos(a(2)).*a(3);
r(3)=sin(a(2)).*a(3);
