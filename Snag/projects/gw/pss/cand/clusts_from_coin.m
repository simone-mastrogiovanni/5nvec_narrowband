function [clcan1,clcan2]=clusts_from_coin(cand1,cand2,coin,kcoin)
% extracts the candidates of the 2 clusters of a coincidence
%
%     [clcan1,clcan2]=clusts_from_coin(cand1,cand2,coin,kcoin)
%
%    cand1,cand2   original candidate structures (not reordered(
%    coin          coincidence structure
%    kcoin         the coincidence to consider

% Snag version 2.0 - December 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

candout1=cand_corr(cand1,coin);
candout2=cand_corr(cand2,coin);

kcl1=coin.coin(1,kcoin);
kcl2=coin.coin(2,kcoin);

ini1=coin.indii1(1,kcl1);
ifi1=coin.indii1(2,kcl1);
ini2=coin.indii2(1,kcl2);
ifi2=coin.indii2(2,kcl2);

clcan1=candout1(ini1:ifi1,:);
clcan2=candout2(ini2:ifi2,:);