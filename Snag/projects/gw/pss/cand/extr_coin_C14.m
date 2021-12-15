function [fr,lam,bet,sd,A,h,d,num,dlam,dbet,clusts,cands,frmi,frma]=extr_coin_C14(coin,isel)
% data extraxtion from coin C14 structures
%
%     [fr,lam,bet,sd,A,h,d,num,clusts,cands]=extr_coin_C14(coin)
%
%    coin   coincidence C14 structure
%    isel   (if present) index selection

% Snag Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

cc=coin.coin;
[dummy,N]=size(cc);

fr=zeros(3,N);
lam=fr;bet=fr;sd=fr;h=fr;frmi=fr;frma=fr;
d=zeros(1,N);
num=zeros(2,N);A=num;clusts=A;cands=A;dlam=A;dbet=A;

fr(1,:)=cc(6,:);
fr(2,:)=cc(15,:);
fr(3,:)=(fr(1,:)+fr(2,:))/2;

lam(1,:)=cc(7,:);
lam(2,:)=cc(16,:);
lam(3,:)=(lam(1,:)+lam(2,:))/2;

bet(1,:)=cc(8,:);
bet(2,:)=cc(17,:);
bet(3,:)=(bet(1,:)+bet(2,:))/2;

sd(1,:)=cc(9,:);
sd(2,:)=cc(18,:);
sd(3,:)=(sd(1,:)+sd(2,:))/2;

h(1,:)=cc(14,:);
h(2,:)=cc(23,:);
h(3,:)=(h(1,:)+h(2,:))/2;

A(1,:)=cc(10,:);
A(2,:)=cc(19,:);

dlam(1,:)=cc(12,:);
dlam(2,:)=cc(21,:);

dbet(1,:)=cc(13,:);
dbet(2,:)=cc(22,:);

d(:)=cc(5,:);

num(1,:)=coin.clust1(1,:);
num(2,:)=coin.clust2(1,:);

clusts(1,:)=cc(1,:);
clusts(2,:)=cc(2,:);

cands(1,:)=cc(3,:);
cands(2,:)=cc(4,:);

frmi(1,:)=coin.clust1(3,:);
frmi(2,:)=coin.clust2(3,:);
frmi(3,:)=min(frmi(1,:),frmi(2,:));

frma(1,:)=coin.clust1(4,:);
frma(2,:)=coin.clust2(4,:);
frma(3,:)=max(frma(1,:),frma(2,:));

if exist('isel','var')
    fr=fr(:,isel);
    lam=lam(:,isel);
    bet=bet(:,isel);
    sd=sd(:,isel);
    h=h(:,isel);
    A=A(:,isel);
    d=d(:,isel);
    dlam=dlam(:,isel);
    dbet=dbet(:,isel);
    num=num(:,isel);
    clusts=clusts(:,isel);
    cands=cands(:,isel);
end