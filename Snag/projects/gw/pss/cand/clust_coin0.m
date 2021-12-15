function coin=clust_coin(in1,in2,cand1,cand2,dist,numer,kepoch,reduce)
%
%   coin=clust_coin(in1,in2,cand1,cand2,dist,numer,kepoch)
%
%   in1,in2     input cluster structures
%               the output frequencies are computed at epoch defined by kepoch
%      .clust   (18,M)
%   cand1,cand2 candidate matrices (N,9)
%   dist        coincidence distance
%   numer       if exist, [min max] numerosity
%   kepoch      coincidence epoch parameter (0 -> T1, 1 -> T2, other in (0,1)
%               (for VSR2-VSR4 1 is suggested)
%   reduce      metrics reducer factors (>1; [fr,lam,bet,sd] or only fr; def [1 1 1 1])
%
%   coin        coincidence structure
%     .info1    info structure group 1
%     .info2    info structure group 2
%     .reduce   metrics reducer factors
%     .Ufr1     frequency uncertainty for group 1
%     .Ufr2     frequency uncertainty for group 2
%     .dfr      frequency coincidence interval
%     .dsd      spin-down coincidence interval
%     .T1       first set epoch
%     .T2       fsecond set epoch
%     .T0       coincidence epoch
%     .dist     coincidence distance (normalized)
%     .kepoch
%     .numer
%     .indcoin  (2,M) cluster1, cluster2
%     .clust1   coincident cluster1
%     .clust2   coincident cluster2
%     .indcand  (2,M) candidate indices
%     .cand1    coincidence cluster candidates
%     .cand2    coincidence cluster candidates
%     .stat     (6,:) frequency statistics: 1 fr, 2 cand1, 3 clust1, 
%                4 cand2, 5 clust2, 6 coin 
%
% %   serv1    (3,n1) maxind, minind, numcoin
% %   serv2    (1,n2) coin1
%
%   cluster matrices (19,N)
%
%         1     Numerosity
%         2     weight (sum of the amplitudes)
%         3     min frequency
%         4     max frequency
%         5     Frequency
%         6     min lambda
%         7     max lambda
%         8     lambda
%         9     min beta
%         10	max beta
%         11	beta
%         12	min spin-down
%         13	max spin-down
%         14	spin-down
%         15	Amplitude
%         16	CR
%         17	mean uncertainty on  lambda  (semi-interval)
%         18	mean uncertainty on  beta  (semi-interval)
%         19    h amplitude
%
%   candidate matrices (9,N)
%         1.	frequency   ?
%         2.	ecl. long.  ?
%         3.	ecl. lat.   ?
%         4.	spin down   d
%         5.	amplitude   A
%         6.	CR (global)
%         7.	Uncertainty on  ?  (semi-interval)
%         8.	Uncertainty on  ?  (semi-interval)
%         9.	h-amplitude

% Version 2.0 - August 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('reduce','var')
    reduce=[1 1 1 1];
end
if length(reduce) == 1
    reduce=[reduce 1 1 1];
end

% DT=in2.T0-in1.T0
DT=in2.info.run.epoch-in1.info.run.epoch;
delay=DT*86400;

[aa, m1]=size(in1.clust);
[aa, m2]=size(in2.clust);

coin.info1=in1.info;
coin.info2=in2.info;
coin.reduce=reduce;

ufr1=in1.dfr/2;
ufr2=in2.dfr/2;
usd1=in1.dsd/2;
usd2=in2.dsd/2;
Ufr1=ufr1+kepoch*delay*usd1;
Ufr2=ufr2+(1-kepoch)*delay*usd2;
coin.Ufr1=Ufr1;
coin.Ufr2=Ufr2;
dfr=(Ufr1+Ufr2)/reduce(1);
dsd=(usd1+usd2)/reduce(4);
coin.dfr=dfr;
coin.dsd=dsd;

coin.T1=in1.info.run.epoch;
coin.T2=in2.info.run.epoch;
coin.T0=(1-kepoch)*coin.T1+kepoch*coin.T2;
coin.dist=dist;
coin.kepoch=kepoch;
coin.numer=numer;

[cand1,index1]=sd_corr(cand1,coin.T1,coin.T0);
index1=in1.index(index1);
[cand2,index2]=sd_corr(cand2,coin.T2,coin.T0);
index2=in2.index(index2);

minfr=round(min(min(cand1(:,1)),min(cand2(:,1))));
maxfr=round(max(max(cand1(:,1)),max(cand2(:,1))));
hfr=minfr+0.05:0.1:maxfr;
nst=length(hfr);
stat=zeros(6,nst);
stat(1,:)=hfr;
stat(2,:)=hist(cand1(:,1),hfr);
stat(3,:)=hist(in1.clust(5,:),hfr);
stat(4,:)=hist(cand2(:,1),hfr);
stat(5,:)=hist(in2.clust(5,:),hfr);
 
[ic0,ia,ic]=unique(index1);
[ic0,ii1]=sort(ic);
ic0d=diff(ic0);
ic0d=[1; ic0d];
ncl=length(ia);
indii1=zeros(2,ncl);
icd=find(ic0d);
indii1(2,:)=[icd(2:length(icd))-1 ; length(ic0d)];
indii1(1,:)=icd;

[ic0,ia,ic]=unique(index2);
[ic0,ii2]=sort(ic);
ic0d=diff(ic0);
ic0d=[1; ic0d];
ncl=length(ia);
indii2=zeros(2,ncl);
icd=find(ic0d);
indii2(2,:)=[icd(2:length(icd))-1 ; length(ic0d)];
indii2(1,:)=icd;

cand1=cand1(ii1,:);
cand2=cand2(ii2,:);

sd1min=in1.clust(12,:)-usd1;
sd1max=in1.clust(13,:)+usd1;
sd1=in1.clust(14,:);
fr1min=in1.clust(3,:)+kepoch*delay*sd1-Ufr1;
dfr1min=max(max(-diff(fr1min)),0);
fr1max=in1.clust(4,:)+kepoch*delay*sd1+Ufr1;
fr1=in1.clust(5,:)+kepoch*delay*sd1;
lam1max=in1.clust(7,:);
lam1min=in1.clust(6,:);
bet1max=in1.clust(10,:);
bet1min=in1.clust(9,:);
num1=in1.clust(1,:);
sprintf('Ufr1 = %f  dfr1min = %f \n',Ufr1,dfr1min),pause(1)

sd2min=in2.clust(12,:)-usd2;
sd2max=in2.clust(13,:)+usd2;
sd2=in2.clust(14,:);
fr2min=in2.clust(3,:)-(1-kepoch)*delay*sd2-Ufr2;
dfr2min=max(max(-diff(fr2min)),0);
fr2max=in2.clust(4,:)-(1-kepoch)*delay*sd2+Ufr2;
fr2=in2.clust(5,:)-(1-kepoch)*delay*sd2;
lam2max=in2.clust(7,:);
lam2min=in2.clust(6,:);
bet2max=in2.clust(10,:);
bet2min=in2.clust(9,:);
num2=in2.clust(1,:);
sprintf('Ufr2 = %f  dfr2min = %f \n',Ufr2,dfr2min),pause(1)

jj1=find(num1 >= numer(1) & num1 <= numer(2)); 
lfr1=max(fr1max(jj1)-fr1min(jj1))
jj1=find(num2 >= numer(1) & num2 <= numer(2));
lfr2=max(fr2max(jj1)-fr2min(jj1))

N=0;
N1=0;
N2=1000;
mm=0;
indcoin=zeros(2,N2);
indcand=indcoin;
cc1=1;
cc2=1;
can1=[];
can2=[];

j1=1;
j=0;
    
for i = 1:m1
    if floor(i/10000)*10000 == i
        cl=clock;
        dN=N-N1;
        N1=N;
        fprintf('i,j,mm,fr,N,dN: %d %d %d %f %d %d  %d:%d:%f \n',i,j,mm,fr1min(i),N,dN,cl(4:6))
    end
    if num1(i) < numer(1) || num1(i) > numer(2)
        continue
    end
    
    mm=mm+1;

    c1=cand1(indii1(1,i):indii1(2,i),:);
    
    for j = j1:m2
        if num2(j) < numer(1) || num2(j) > numer(2)
            continue
        end
        if fr2min(j) > fr1max(i)+dfr1min+dfr2min
            break
        end
        if bet1min(i) > bet2max(j)
            continue
        end
        if bet2min(j) > bet1max(i)
            continue
        end
        if lam1min(i) > lam2max(j) && lam2max(j)-lam2min(j) < 180 && lam1max(i)-lam1min(i) < 180
            continue
        end
        if lam2min(j) > lam1max(i) && lam2max(j)-lam2min(j) < 180 && lam1max(i)-lam1min(i) < 180
            continue
        end
        if fr2min(j)+lfr2 < fr1min(i)
            j1=j+1;
            continue
        end
            
        c2=cand2(indii2(1,j):indii2(2,j),:); %size(c1),size(c2)
            
        for ii = 1:indii1(2,i)-indii1(1,i)+1
            d=distance(c1(ii,:),c2,dfr,dsd,reduce);
            if d <= dist
                N=N+1;
                if N > N2
                    indcoin(:,N2+1:N2+1000)=zeros(2,1000);
                    indcand(:,N2+1:N2+1000)=zeros(2,1000);
                    N2=N2+1000;
                end
                indcoin(1,N)=i;
                indcoin(2,N)=j;
                indcand(1,N)=cc1;
                indcand(2,N)=cc2;
                can1=[can1 c1'];
                can2=[can2 c2'];
                cc1=cc1+indii1(2,i)-indii1(1,i)+1;
                cc2=cc2+indii2(2,j)-indii2(1,j)+1;
                break
            end
        end
    end
end

coin.indcoin=indcoin(:,1:N);

coin.clust1=in1.clust(:,indcoin(1,1:N));
coin.clust2=in2.clust(:,indcoin(2,1:N));
coin.indcand=indcand(:,1:N);
coin.cand1=can1';
coin.cand2=can2';

stat(6,:)=hist((coin.clust1(5,:)+coin.clust1(5,:))/2,hfr);
coin.stat=stat;


function d=distance(const,arr,dfr,dsd,reduce)

d=min(sqrt(...
    ((const(1)-arr(:,1))/dfr).^2+...
    ((const(4)-arr(:,4))/dsd).^2+...
    ((const(2)-arr(:,2))./((const(7)+arr(:,7))/reduce(2))).^2+...
    ((const(3)-arr(:,3))./((const(8)+arr(:,8))/reduce(3))).^2 ...
    ));


function [cand ind]=sd_corr(cand,epoch,epochcoin)

fr=cand(:,1)+cand(:,4)*(epochcoin-epoch)*86400;

[fr ind]=sort(fr);
cand=cand(ind,:);
cand(:,1)=fr;