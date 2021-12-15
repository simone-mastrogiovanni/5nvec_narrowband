function [rr,vv,NN,r,theta,dtheta]=base_elliptic_orbit(ecc,sma,N)
% elliptic orbit
%
%   [rr,vv,r,theta]=elliptic_orbit(ecc,msa,N)
%
%    ecc     eccentricity
%    sma     semi-major axis
%    N       number of points
%
%    rr      cartesian reduced coordinates
%    vv      cartesian velocities
%    r,theta polar coordinates
%
%  equation r=a*(1-e^2)/(1+e*cos(th))

% Snag Version 2.0 - March 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

r=zeros(1,2*N);
theta=r;
dtheta=r;
dthet0=2*pi/N;
i=0;

thet=0;

while thet < 2*pi
    i=i+1;
    r(i)=sma*(1-ecc^2)/(1+ecc*cos(thet));
    theta(i)=thet;
    dtheta(i)=dthet0*(1+ecc*cos(thet)).^2;
    thet=thet+dtheta(i);
end

r=r(1:i);
theta=theta(1:i);
dtheta=dtheta(1:i);
NN=i;
rr=zeros(2,1*NN);
vv=rr;

rr(1,:)=-r.*cos(theta);
rr(2,:)=r.*sin(theta);
vv(:,1:NN-1)=rr(:,2:NN)-rr(:,1:NN-1);
vv(:,NN)=(vv(:,1)+vv(:,NN-1))/2;

