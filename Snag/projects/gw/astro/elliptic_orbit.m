function [dop,rom,harm]=elliptic_orbit(per,sma,ecc,obs,N)
% doppler and roemer for elliptic orbit
%
%   [dop,rom,harm]=elliptic_orbit(per,sma,ecc,obs,N)
%
%    per     period
%    sma     semi-major axis
%    ecc     eccentricity
%    obs     observer direction (two angles [rotation,pitch], in degrees)
%    N       number of points
% 
%    dop     doppler shift
%    rom     roemer delay
%    harm    first 20 normalized harmonics

% Snag Version 2.0 - March 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[rr,vv,NN,r,theta,dtheta]=base_elliptic_orbit(ecc,sma,N);

R=zeros(3,NN);
V=R;
R(1:2,:)=rr;
V(1:2,:)=vv;

R=euler_rot(R,obs(1),obs(2),0);
V=euler_rot(V,obs(1),obs(2),0);

rom=R(3,:);
dop=V(3,:);
f=fft(dop);
harm(1:20)=f(2:21)/sqrt(sum(abs(f).^2));

rom=gd(rom);
rom=edit_gd(rom,'dx',per/NN);
dop=gd(dop);
dop=edit_gd(dop,'dx',per/NN);