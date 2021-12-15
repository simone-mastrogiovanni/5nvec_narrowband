function ang=astro_angle(in1,in2)
%ASTRO_ANGLE  angle between two sky points
%
%   in1,in2   sky points coordinate [a,d] or similar
%
% All angles are in degrees

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

rad2deg=180/pi;

cin1=sky2cart(in1);
cin2=sky2cart(in2);
sp=sum(cin1.*cin2);
ang=acos(sp)*rad2deg;


function c=sky2cart(s)

deg2rad=pi/180;

s=s*deg2rad;
c(3)=sin(s(2));
cc=sqrt(1-c(3).^2);
c(1)=cos(s(1))*cc;
c(2)=sin(s(1))*cc;

%sum(c.^2)