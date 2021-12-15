function [a d]=unif_sky(N)
% UNIF_sky  uniformly distributed sources on sky (or antennas on Earth)

a=rand(1,N)*360;
z=rand(1,N)*2-1;
d=asin(z)*180/pi;