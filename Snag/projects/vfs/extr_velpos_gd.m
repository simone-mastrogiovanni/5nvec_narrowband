function VPstr=extr_velpos_gd(bsdgd)
% extracts velocity and position from a BSD gd
%
%   VPstr.VP(:,8)   central mjd, vel(3), pos(3), central gps_s

% Version 2.0 - June 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

cont=cont_gd(bsdgd);
[siz,dummy]=size(cont.v_eq);

VPstr.VP=zeros(siz,8);

VPstr.VP(:,2:4)=cont.v_eq(:,1:3);
VPstr.VP(:,5:8)=cont.p_eq(:,1:4);
t0=cont.t0;
t0gps=mjd2gps(t0);
VPstr.VP(:,1)=gps2mjd(t0gps+cont.v_eq(:,4));

VPstr.t0=t0;
VPstr.t0gps=t0gps;
VPstr.dt=dx_gd(bsdgd);
VPstr.n=n_gd(bsdgd);