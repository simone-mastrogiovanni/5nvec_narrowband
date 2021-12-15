function [cl1,cl2,can1,can2]=disp_coin(kcoin,coin,verb,iii)
% displays coincidences
%
%   [cl1,cl2,can1,can2]=disp_coin(kcoin,coin,verb)
%
%  kcoin   sequential number of coincidence
%  coin    coincidence structure
%  verb    verbosity 0,1
%  iii     if present, selection on coin

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if exist('iii','var')
    coin.clust1=coin.clust1(:,iii);
    coin.clust2=coin.clust2(:,iii);
    coin.cref=coin.cref(iii,:);
end
cl1=coin.clust1(:,kcoin);
cl2=coin.clust2(:,kcoin);
cref=coin.cref(kcoin,:);
can1=coin.cand1(cref(2),:);
can2=coin.cand2(cref(3),:);
dsd1=coin.info1.sd.dnat;
dsd2=coin.info2.sd.dnat;

if verb > 0
    fprintf('   Coincidence %d  distance=%f\n',kcoin,cref(1))
    fprintf('cluster1 num = %d, fr = (%f,%f), amp = %f\n',cl1(1),cl1(3),cl1(4),cl1(15));
    fprintf('cluster2 num = %d, fr = (%f,%f), amp = %f\n',cl2(1),cl2(3),cl2(4),cl2(15));
    fprintf('  Reference candidate (%d, %d)\n',cref(2),cref(3));
    fprintf('freq: %f %f\n',can1(1),can2(1));
    fprintf('s.d.: %e %e (nat %.3f %.3f)\n',can1(4),can2(4),can1(4)/dsd1,can2(4)/dsd2);
    fprintf('lamb: %.2f %.2f\n',can1(2),can2(2));
    fprintf('beta: %.2f %.2f\n',can1(3),can2(3));
    fprintf(' amp: %.2f %.2f\n',can1(5),can2(5));
    fprintf('  CR: %.2f %.2f\n',can1(6),can2(6));
    fprintf('   h: %e %e\n',can1(9),can2(9));
end