function [cl1,cl2,can1,can2]=disp_coin_C14(kcoin,coin)
% displays coincidences
%
%   [cl1,cl2,can1,can2]=disp_coin(kcoin,coin,verb)
%
%  kcoin   coincidence sequential number
%  coin    coincidence structure

% Snag Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[fr,lam,bet,sd,A,h,d,num,clusts,cands]=extr_coin_C14(coin,kcoin);
cc=coin.coin(:,kcoin);

cl1=coin.clust1(:,kcoin);
cl2=coin.clust2(:,kcoin);
kcl1=clusts(1);
kcl2=clusts(2);
kcan1=cands(1);
kcan2=cands(2);
can1=cc(6:14);
can2=cc(15:23);
dsd1=coin.info1.sd.dnat;
dsd2=coin.info2.sd.dnat;

fprintf('   Coincidence %d  clusters %d %d  cands %d %d  distance=%f\n',kcoin,kcl1,kcl2,kcan1,kcan2,d)
fprintf('cluster1 num = %d, fr = (%f,%f), amp = %f\n',cl1(1),cl1(3),cl1(4),cl1(15));
fprintf('cluster2 num = %d, fr = (%f,%f), amp = %f\n',cl2(1),cl2(3),cl2(4),cl2(15));
% fprintf('  Reference candidate (%d, %d)\n',cref(2),cref(3));
fprintf('freq: %f  (%f %f)\n',fr(3),can1(1),can2(1));
fprintf('s.d.: %e  (%e %e) (nat %.3f %.3f)\n',sd(3),can1(4),can2(4),can1(4)/dsd1,can2(4)/dsd2);
fprintf('lamb: %f  (%.2f %.2f)\n',lam(3),can1(2),can2(2));
fprintf('beta: %f  (%.2f %.2f)\n',bet(3),can1(3),can2(3));
fprintf(' amp: %.2f %.2f\n',can1(5),can2(5));
fprintf('  CR: %.2f %.2f\n',can1(6),can2(6));
fprintf('   h: %e  (%e %e)\n',h(3),can1(9),can2(9));