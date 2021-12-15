function out=im_torus_rot(in,ix,iy)
%IM_TORUS_ROT  image torus rotation
%
%   in     input image
%   ix,iy  how much to rotate

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[ny,nx]=size(in);
ix=mod(ix,nx);
iy=mod(iy,ny);
out=in*0;
out1=in*0;

out1=in(iy+1:ny,:);
out1(ny-iy+1:ny,1:nx)=in(1:iy,:);

out=out1(:,ix+1:nx);
out(1:ny,nx-ix+1:nx)=out1(:,1:ix);