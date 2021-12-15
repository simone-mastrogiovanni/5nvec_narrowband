function [dopin,dopout]=check_bsd_doppler(in,doptabs)
% checks the dopper of a bsd

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=ccont_gd(in);
ant=cont.ant;

dopin.v_eq=cont.v_eq;
dopin.p_eq=cont.p_eq;
dopin.t=adds2mjd(cont.t0,cont.v_eq(:,4));

[vel pos ein tout]=dop_ant(ant,dopin.t,doptabs);

dopout.vel=vel;
dopout.pos=pos;
dopout.ein=ein;
dopout.t=tout;

figure,plot(tout-tout(1),dopin.v_eq(:,1),'.')
hold on,plot(tout-tout(1),dopin.v_eq(:,2),'r.'),grid on
plot(tout-tout(1),dopin.v_eq(:,3),'.g')
title('velocity components')

figure,plot(tout-tout(1),dopin.v_eq(:,1)-dopout.vel(:,1),'.'),grid on
hold on,plot(tout-tout(1),dopin.v_eq(:,2)-dopout.vel(:,2),'r.'),grid on
plot(tout-tout(1),dopin.v_eq(:,3)-dopout.vel(:,3),'g.'),grid on
title('velocity errors')

figure,plot(tout-tout(1),(dopin.v_eq(:,1)-dopout.vel(:,1))./dopout.vel(:,1),'.')
hold on,plot(tout-tout(1),(dopin.v_eq(:,2)-dopout.vel(:,2))./dopout.vel(:,2),'r.')
plot(tout-tout(1),(dopin.v_eq(:,3)-dopout.vel(:,3))./dopout.vel(:,3),'g.'),grid on
title('velocity relative errors')

figure,plot(tout-tout(1),dopin.p_eq(:,1),'.')
hold on,plot(tout-tout(1),dopin.p_eq(:,2),'r.'),grid on
plot(tout-tout(1),dopin.p_eq(:,3),'.g')
title('position components')

figure,plot(tout-tout(1),dopin.p_eq(:,1)-dopout.pos(:,1),'.'),grid on
hold on,plot(tout-tout(1),dopin.p_eq(:,2)-dopout.pos(:,2),'r.'),grid on
plot(tout-tout(1),dopin.p_eq(:,3)-dopout.pos(:,3),'g.'),grid on
title('position errors')

figure,plot(tout-tout(1),(dopin.p_eq(:,1)-dopout.pos(:,1))./dopout.vel(:,1),'.')
hold on,plot(tout-tout(1),(dopin.p_eq(:,2)-dopout.pos(:,2))./dopout.vel(:,2),'r.')
plot(tout-tout(1),(dopin.p_eq(:,3)-dopout.vel(:,3))./dopout.pos(:,3),'g.'),grid on
title('position relative errors')