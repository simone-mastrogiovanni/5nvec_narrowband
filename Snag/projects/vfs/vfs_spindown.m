function sd=vfs_spindown(gpar,sdpar,ic)
% creation/correction spin-down frequency variation
%
%     sd=vfs_spindown(gin,sdpar,ic)
%
%   gpar    data gd dt and n
%   sdpar   spin-down parameters array at epoch ini of the gd
%   ic      1/-1  creation/correction

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J Piccinni, S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=gpar(1);
n=gpar(2);
sd=zeros(1,n);

nord=length(sdpar);
fac=1;

for i = 1:nord
    fac=fac*i;
    sd=sd+(sdpar(i)*((0:n-1)*dt).^i)/fac;
end

sd=sd*ic;