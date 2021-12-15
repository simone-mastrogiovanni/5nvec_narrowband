function out=euler_rot(in,ang1,ang2,ang3)
% Euler rotation for arrays of 3d vectors
%
%   in     input data
%   angs   angles (rot1, pitch, rot2; in degrees)
%           rot around z, pitch around x

% Snag Version 2.0 - March 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[N1,N2]=size(in);
trasp=0;

if N1 ~= 3
    in=in';
    trasp=1;
end

ang1=ang1*pi/180;
ang2=ang2*pi/180;
ang3=ang3*pi/180;

D=[cos(ang1) sin(ang1) 0; -sin(ang1) cos(ang1) 0; 0 0 1];
C=[1 0 0; 0 cos(ang2) sin(ang2); 0 -sin(ang2) cos(ang2)];
B=[cos(ang3) sin(ang3) 0; -sin(ang3) cos(ang3) 0; 0 0 1];

A=B*C*D;

out=A*in;

if trasp == 1
    out=out';
end