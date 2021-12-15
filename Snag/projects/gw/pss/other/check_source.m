% check_source

% caricare candidati ref VSR2 e VSR4 e coin
%
% V2='VSR2_1_120130_ref'
% eval(['load ' V2])
% eval(['VSR2ref=' V2])
% 
% V4='VSR4_1_120130_ref'
% eval(['load ' V4])
% eval(['VSR4ref=' V4])
%
% load('coin_1_120130_C14_2.mat')
% coin=coin_1_120130_C14_2

dfr=VSR2ref.info.run.fr.dnat;
dsd=(VSR2ref.info.sd.dnat+VSR4ref.info.sd.dnat)/2;

ksour=491;
% ksour=494;

fr0=sour(:,1);
sd0=sour(:,4);
sour0=sour;
epoch_sour=5.511172409e+04;
epoch_coin=coin.T0;
DFR=sd0*(epoch_coin-epoch_sour)*86400;
fr=fr0+DFR;
sour0(:,1)=fr;
sourA=sour0(ksour,:);

dmax=2;

[cand1,cand2]=softinj_cands(VSR2ref,VSR4ref,coin);

[ii1,dd1,d1a,d2a,d3a,d4a]=dist_sour(sourA,cand1,dmax,dfr,dsd);
[ii2,dd2,d1b,d2b,d3b,d4b]=dist_sour(sourA,cand2,dmax,dfr,dsd);

ccand1=cand1(ii1,:);
ccand2=cand2(ii2,:);

n1=length(ii1);
n2=length(ii2);
dd=zeros(n1,n2);
d1=dd;d2=dd;d3=dd;d4=dd;

for i = 1:n1
    [dd(i,:),d1(i,:),d2(i,:),d3(i,:),d4(i,:)]=distance_4(ccand1(i,:),ccand2,dfr,dsd);
end