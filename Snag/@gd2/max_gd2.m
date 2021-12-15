function [x,y,v,ix,iy]=max_gd2(g2)
% max of a gd2
%
%    g2     a gd2

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Y=g2.y;
x=x_gd2(g2);
y=x2_gd2(g2);

[M,I]=max(Y);
[MM,I2]=max(M);

x=x(I(I2));
y=y(I2);
v=Y(I(I2),I2);
ix=I(I2);
iy=I2;