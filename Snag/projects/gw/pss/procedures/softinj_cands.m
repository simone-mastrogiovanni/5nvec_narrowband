function [cand1,cand2]=softinj_cands(VSR2ref,VSR4ref,coin)

% VSR2ref,VSR4ref
cand1=cand_corr(VSR2ref,coin);
cand2=cand_corr(VSR4ref,coin);

% size(cand1),size(cand2)
