function ang=astro_angle_m(in1,in2)
%ASTRO_ANGLE  angles between couples of sky points
%
%   in1,in2   N sky points couples coordinate [a,d] or similar;
%             each is (N,2); if one is (1,2), it is fixed for all the N
%
% All angles are in degrees

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

rad2deg=180/pi;

[N1,nn]=size(in1);
[N2,nn]=size(in2);
N=max(N1,N2);

if N1 == 1
    in1(1:N,1)=in1(1,1);
    in1(1:N,2)=in1(1,2);
end
if N2 == 1
    in2(1:N,1)=in2(1,1);
    in2(1:N,2)=in2(1,2);
end

cin1=sky2cart(in1);
cin2=sky2cart(in2);
sp=cin1(:,1).*cin2(:,1)+cin1(:,2).*cin2(:,2)+cin1(:,3).*cin2(:,3);
ang=acos(sp)*rad2deg;


function c=sky2cart(s)

deg2rad=pi/180;
[N,nn]=size(s);
c=zeros(N,3);

s=s*deg2rad;
c(:,3)=sin(s(:,2));
cc=sqrt(1-c(:,3).^2);
c(:,1)=cos(s(:,1)).*cc;
c(:,2)=sin(s(:,1)).*cc;

%sum(c.^2)