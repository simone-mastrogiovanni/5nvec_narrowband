function out=ana_sel_coin(coin,selcoin)
%
%   ana_sel_coin(coin,selcoin)
%
%   coin      coin structure
%   selcoin   selected coincidence indices (if absent, all)
%

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca & Sabrina D'Antonio - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out.T1=coin.T1;
out.T2=coin.T2;
out.T0=coin.T0;
% cref=coin.cref;

[dum,N]=size(coin.indcoin);
if ~exist('selcoin','var')
    selcoin=1:N;
end
[n1,dum]=size(coin.cand1);
[n2,dum]=size(coin.cand2);
indcand=coin.indcand; 
indcand(1:2,N+1)=[n1+1,n2+1];
dfr=coin.dfr;
dsd=coin.dsd;

M=length(selcoin);
PAR1=zeros(M,11);
PAR2=PAR1;

for i = 1:length(selcoin)
    jj=selcoin(i);
    cand1=coin.cand1(indcand(1,jj):indcand(1,jj+1)-1,:);
%     [aa,ii1]=max(cand1(:,5));
    cand2=coin.cand2(indcand(2,jj):indcand(2,jj+1)-1,:);
%     [aa,ii2]=max(cand2(:,5));

    PAR1(i,:)=clust_par(cand1);
    PAR2(i,:)=clust_par(cand2);
    
%     cspot(i).cl1.numer=coin.clust1(1,jj);
%     [dum,k]=max(cand1(:,5));
%     cspot(i).cl1.maxA=cand1(k,:);
%     cspot(i).cl1.cref=coin.cand2(cref(jj,2),:);
%     cspot(i).cl2.numer=coin.clust1(1,jj);
%     [dum,k]=max(cand2(:,5));
%     cspot(i).cl2.maxA=cand2(k,:);
%     cspot(i).cl2.cref=coin.cand2(cref(jj,3),:);
end

out.PAR1=PAR1;
out.PAR2=PAR2;