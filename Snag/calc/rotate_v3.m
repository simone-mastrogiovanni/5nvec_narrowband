function vout=rotate_v3(r,phi,theta)
% creates a [3 n] vector whith polar coordinates r, phi, theta
%  
%   vout=rotate_v3(r,phi,theta)
%
%   r           a vector of dimension n
%   phi,theta   numbers or n-vectors (degrees)

% Version 2.0 - June 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg2rad=pi/180;

vout(1,:)=r.*sin(theta*deg2rad).*cos(phi*deg2rad);
vout(2,:)=r.*sin(theta*deg2rad).*sin(phi*deg2rad);
vout(3,:)=r.*cos(theta*deg2rad);