function out=show_sel_coin(coin,secoin,tit)
%
%   show_sel_coin(coin,secoin)
%
%   coin      coin structure
%   secoin    structure with selind, bsel and spotind
%   tit       plot title; if "noplot" no plot
%
%   out.T1    cluster1 epoch
%   out.T2    cluster2 epoch
%   out.T0    coincidence epoch
%   out.spot               spot structure array 
%   out.spot(k).cl1.maxA
%                  .cref
%                  .numer
%              .cl2.maxA
%                  .cref
%                  .numer

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca & Sabrina D'Antonio - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('tit','var')
    tit=' ';
end
icplot=1;
if strcmpi(tit,'noplot')
    icplot=0;
end

cspot=struct([]);
out.T1=coin.T1;
out.T2=coin.T2;
out.T0=coin.T0;
cref=coin.cref;

spot=secoin.spotind;
sel=secoin.selind(spot);
[dum,N]=size(coin.indcoin);
[n1,dum]=size(coin.cand1);
[n2,dum]=size(coin.cand2);
indcand=coin.indcand; 
indcand(1:2,N+1)=[n1+1,n2+1];
dfr=coin.dfr;
dsd=coin.dsd;

if icplot > 0
    figure,hold on,grid on
    for i = 1:length(spot)
        jj=sel(i);
        cand1=coin.cand1(indcand(1,jj):indcand(1,jj+1)-1,:);
        [aa,ii1]=max(cand1(:,5));
        cand2=coin.cand2(indcand(2,jj):indcand(2,jj+1)-1,:);
        [aa,ii2]=max(cand2(:,5));
        plot(cand1(ii1,1),cand1(ii1,4),'.'),plot(cand2(ii2,1),cand2(ii2,4),'r.')
    end
    title(tit),xlabel('Hz'),ylabel('sd')
end

for i = 1:length(spot)
    jj=sel(i);
    cand1=coin.cand1(indcand(1,jj):indcand(1,jj+1)-1,:);
    [aa,ii1]=max(cand1(:,5));
    cand2=coin.cand2(indcand(2,jj):indcand(2,jj+1)-1,:);
    [aa,ii2]=max(cand2(:,5));
    if icplot > 0
        figure
        subplot(2,2,1)
        plot(cand1(:,1),cand1(:,4),'.'),hold on,grid on,plot(cand2(:,1),cand2(:,4),'r.')
        plot(cand1(ii1,1),cand1(ii1,4),'O'),plot(cand2(ii2,1),cand2(ii2,4),'rO'),title(sprintf('%d: sd vs f',i))
        subplot(2,2,2)
        plot(cand1(:,2),cand1(:,3),'.'),hold on,grid on,plot(cand2(:,2),cand2(:,3),'r.')
        plot(cand1(ii1,2),cand1(ii1,3),'O'),plot(cand2(ii2,2),cand2(ii2,3),'rO'),title('bet vs lam')
        subplot(2,2,3)
        plot(cand1(:,1),cand1(:,2),'.'),hold on,grid on,plot(cand2(:,1),cand2(:,2),'r.')
        plot(cand1(ii1,1),cand1(ii1,2),'O'),plot(cand2(ii2,1),cand2(ii2,2),'rO'),title('lam vs f')
        subplot(2,2,4)
        plot(cand1(:,2),cand1(:,4),'.'),hold on,grid on,plot(cand2(:,2),cand2(:,4),'r.')
        plot(cand1(ii1,2),cand1(ii1,4),'O'),plot(cand2(ii2,2),cand2(ii2,4),'rO'),title('sd vs lam')
    end
    
    cspot(i).cl1.numer=coin.clust1(1,jj);
    [dum,k]=max(cand1(:,5));
    cspot(i).cl1.maxA=cand1(k,:);
    cspot(i).cl1.cref=coin.cand2(cref(jj,2),:);
    cspot(i).cl2.numer=coin.clust1(1,jj);
    [dum,k]=max(cand2(:,5));
    cspot(i).cl2.maxA=cand2(k,:);
    cspot(i).cl2.cref=coin.cand2(cref(jj,3),:);
end

out.spot=cspot;