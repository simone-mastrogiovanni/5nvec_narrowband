function [newbsd,v_eq,p_eq]=bsd_new_p_v(bsdin,doptab,DT)
% recomputes postion and velocity
%
%   DT       time intervals (s)

% Version 2.0 - May 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=cont_gd(bsdin);
tin=cont.t0;
dt=dx_gd(bsdin);
n=n_gd(bsdin);
tfi=tin+n*dt/86400;

[v_eq,p_eq]=doptab2vp_eq(doptab,tin,tfi,DT);

cont.v_eq=v_eq;
cont.p_eq=p_eq;

newbsd=edit_gd(bsdin,'cont',cont);