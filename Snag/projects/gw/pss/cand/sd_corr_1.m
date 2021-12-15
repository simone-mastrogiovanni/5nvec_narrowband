function [cand, ind, DFR]=sd_corr_1(cand,epoch,epochcoin,nosort)
%
%  if exist nosort, no sort

DFR=cand(:,4)*(epochcoin-epoch)*86400;
fr=cand(:,1)+DFR;

if ~exist('nosort','var')
    [fr, ind]=sort(fr);
    cand=cand(ind,:);
else
    ind=[];
end
cand(:,1)=fr;