function gout=vfs_create_1(n,dt,fr0,frph,ic)
% create varying frequency signals
%
%     gout=vfs_create_1(n,dt,fr0,frph,ic)
%
%   n      number of samples
%   dt     sampling time (negative -> complex signal)
%   fr0    main frequency
%   frph   varying frequency or phase
%   ic     = 0  frequecy additive
%          = 1  frequency multiplicative 
%          = 2  phase 

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

icreal=1;
if dt < 0
    dt=-dt;
    icreal=0;
end

t=(0:n-1)'*dt;
T=n*dt;
icph=0;
icmul=0;

switch ic
    case 0
        frph=fr0+frph;
        gout=cumsum(frph)*dt*2*pi;
    case 1
        icmul=1;
        frph=fr0*(1+frph);
        gout=cumsum(frph)*dt*2*pi;
    case 2
        icph=1;
        gout=frph;
end

if icreal == 1
    gout=cos(gout);
else
    gout=exp(gout*1j);
end

% if sum(fr > 0.5/dt)
%     disp('ATTENTION ! high sampling time')
% end
    
gout=gd(gout);
gout=edit_gd(gout,'dx',dt);