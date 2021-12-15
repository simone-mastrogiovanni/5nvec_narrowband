function dist=spherical_distance(a1,d1,a2,d2)
%
%  all angles are in deg

[Dist,PA]=sphere_dist(a1,d1,a2,d2,'deg');
dist=Dist*180/pi;