function clustout=clust_from_cand(kgroup,kcands,coin)
% finds the cluster numbers for a candidate
%
%   clustout=clust_from_cand(kgroup,kcand,coin)
%
%   kgroup   1 or 2: which coincident run
%   kcand    candidate numbers (in the cluster ordered matrix, created by cand_corr
%   coin     coincidence structure

% Snag Version 2.0 -July 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

clustout=zeros(1,length(kcands));

if kgroup == 1
    ind=coin.indii1;
else
    ind=coin.indii2;
end

for i = 1:length(kcands)
    clustout(i)=find(ind(1,:) <= kcands(i) & ind(2,:) >= kcands(i));
end