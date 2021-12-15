function vs=bsd_v_dv(VPstr_bsd,direc,t)


% Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome


VPstr=extr_velpos_gd(bsdcor);
Tvel_pt=unique(tfstr.pt.tpeaks); 
[~,v]=interp_VP(VPstr,direct,Tvel_pt);