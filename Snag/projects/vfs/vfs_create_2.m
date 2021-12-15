function gout=vfs_create_2(gin,frph,ic)
% create varying frequency signals
%
%     gout=vfs_create_1(n,dt,fr0,frph,ic)
%
%   gin    input gd analytic signal
%   frph   varying frequency or phase 
%   ic     = 0  frequecy 
%          = 1  phase 

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(gin);
n=n_gd(gin);
T=n*dt;

switch ic
    case 0
        gout=cumsum(frph)*dt*2*pi;
    case 1
        gout=frph;
end

gout=exp(gout*1j).*y_gd(gin);
    
gout=gd(gout);
gout=edit_gd(gout,'dx',dt);