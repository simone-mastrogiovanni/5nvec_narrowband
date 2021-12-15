function [cout, selind]=sel_coin_old(coin,num,w,fr,lam,bet,sd,amp)
%
%     cout=sel_coin(coin,num,w,fr,lam,bet,amp)
%
%   coin     coincidence structure
%   other    selection parameters: 0, no selection, or [min max] allowed
%            or [min1 max1 min2 max2] allowed

% Version 2.0 - August 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ii1=0;ii2=0;ii3=0;ii4=0;ii5=0;ii6=0;ii7=0;
cout=coin;
clust1=coin.clust1;
clust2=coin.clust2;
indcoin=coin.indcoin;

[n1,n2]=size(clust1);
sel=1:n2;

if length(num) > 1
     if length(num) == 2
         num(4)=num(2);
         num(3)=num(1);
     end
     ii1=find((clust1(1,:) >= num(1) & clust1(1,:) <= num(2)) | ...
         (clust2(1,:) >= num(3) & clust2(1,:) <= num(4)));
     clust1=clust1(:,ii1);
     clust2=clust2(:,ii1);
     indcoin=indcoin(:,ii1);
     sel=sel(ii1);
end

if length(w) > 1
     if length(w) == 2
         w(4)=w(2);
         w(3)=w(1);
     end
     ii2=find((clust1(2,:) >= w(1) & clust1(2,:) <= w(2)) | ...
         (clust2(2,:) >= w(3) & clust2(2,:) <= w(4)));
     clust1=clust1(:,ii2);
     clust2=clust2(:,ii2);
     indcoin=indcoin(:,ii2);
     sel=sel(ii2);
end

if length(fr) > 1
     app0=(clust1(5,:)+clust2(5,:))/2;
     ii3=find(app0 >= fr(1) & app0 <= fr(2));
     clust1=clust1(:,ii3);
     clust2=clust2(:,ii3);
     indcoin=indcoin(:,ii3);
     sel=sel(ii3);
end

if length(lam) > 1
     app0=(clust1(8,:)+clust1(8,:))/2;
     ii4=find(app0 >= lam(1) & app0 <= lam(2));
     clust1=clust1(:,ii4);
     clust2=clust2(:,ii4);
     indcoin=indcoin(:,ii4);
     sel=sel(ii4);
end

if length(bet) > 1
     app0=(clust1(11,:)+clust1(11,:))/2;
     ii5=find(app0 >= bet(1) & app0 <= bet(2));
     clust1=clust1(:,ii5);
     clust2=clust2(:,ii5);
     indcoin=indcoin(:,ii5);
     sel=sel(ii5);
end

if length(sd) > 1
     app0=(clust1(14,:)+clust1(14,:))/2;
     ii6=find(app0 >= sd(1) & app0 <= sd(2));
     clust1=clust1(:,ii6);
     clust2=clust2(:,ii6);
     indcoin=indcoin(:,ii6);
     sel=sel(ii6);
end

if length(amp) > 1
     if length(amp) == 2
         amp(4)=amp(2);
         amp(3)=amp(1);
     end
     ii7=find((clust1(15,:) >= amp(1) & clust1(15,:) <= amp(2)) | ...
         (clust2(15,:) >= amp(3) & clust2(15,:) <= amp(4)));
     clust1=clust1(:,ii7);
     clust2=clust2(:,ii7);
     indcoin=indcoin(:,ii7);
     sel=sel(ii7);
end

cout.clust1=clust1; 
cout.clust2=clust2;
cout.indcoin=indcoin;
cout.sel=sel;

selind.num=ii1;
selind.w=ii2;
selind.fr=ii3;
selind.lam=ii4;
selind.bet=ii5;
selind.sd=ii6;
selind.amp=ii7;