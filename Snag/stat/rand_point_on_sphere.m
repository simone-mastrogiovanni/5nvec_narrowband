function out=rand_point_on_sphere(N)
%RAND_POINT_ON_SPHERE  creates N random points on a sphere (alpha,delta)

out=rand(N,2);
out(:,1)=out(:,1)*360;
out(:,2)=asin((out(:,2)-0.5)*2)*180/pi;