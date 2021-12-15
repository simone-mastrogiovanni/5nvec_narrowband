function coin=clust_coin_4(in1,in2,cand1,cand2,dist,numer,kepoch,reduce,m1lim)
%
% Coincidence 2014 format (C14) - Only cand procedure
%
%   coin=clust_coin(in1,in2,cand1,cand2,dist,numer,kepoch)
%
%   in1,in2       input cluster structures
%                 the output frequencies are computed at epoch defined by kepoch
%      .clust      (19,M)
%   cand1,cand2   candidate structures or matrices (N,9)
%   dist          coincidence distance
%   numer         if exist, [min max] numerosity
%   kepoch        coincidence epoch parameter (0 -> T1, 1 -> T2, other in (0,1)
%                  (for VSR2-VSR4 1 is suggested)
%   reduce        metrics reducer factors (>1; [fr,lam,bet,sd] or only fr; def [1 1 1 1])
%   m1lim         limit on m1
%
%   coin          output coincidence structure
%     .start      start time
%     .inpclust1
%     .inpclust2
%     .inpcand1
%     .inpcand2
%     .m1         number of cluster 1
%     .m2         number of cluster 2
%     .info1      info structure group 1
%     .info2      info structure group 2
%     .reduce     metrics reducer factors
%     .Ufr1       frequency uncertainty for group 1
%     .Ufr2       frequency uncertainty for group 2
%     .dfr        frequency coincidence interval
%     .dsd        spin-down coincidence interval
%     .T1         first set epoch
%     .T2         fsecond set epoch
%     .T0         coincidence epoch
%     .dist       coincidence distance (normalized)
%     .kepoch
%     .numer      min,max numerosity queried
%     .indii1     [2,N] min,max permuted candidates 1
%     .indii2     [2,N] min,max permuted candidates 2
%     .perm1      permutation on input cand1
%     .perm2      permutation on input cand2
%     .nomin      errors on the limits
%     .nomax      errors on the limits
%     .MINJ       min cluster of the second group
%     .MAXJ       max cluster of the second group
%     .clust1     coincident cluster1
%     .clust2     coincident cluster2
%     .coin       coin matrix
%     .stat       (6,:) frequency statistics: 1 fr, 2 cand1, 3 clust1, 
%                  4 cand2, 5 clust2, 6 coin 
%     .computer
%     .workdir
%     .ftime      computing time
%
%   coin matrix for nearest  candidates (23,N) 
%
%         1.    cluster 1
%         2.    cluster 2
%         3.    nearest candidate k in the cluster 1
%         4.    nearest candidate k in the cluster 2
%         5.    distance
%         6.	frequency   nu1
%         7.	ecl. long.  lam1
%         8.	ecl. lat.   bet1
%         9.	spin down   d1
%        10.	amplitude   A1
%        11.	CR1 (global)
%        12.	Uncertainty on  lam1  (semi-interval)
%        13.	Uncertainty on  bet1  (semi-interval)
%        14.	h-amplitude 1
%        15.	frequency   nu2
%        16.	ecl. long.  lam2
%        17.	ecl. lat.   bet2
%        18.	spin down   d2
%        19.	amplitude   A2
%        20.	CR2 (global) 
%        21.	Uncertainty on  lam2  (semi-interval)
%        22.	Uncertainty on  bet2  (semi-interval)
%        23.	h-amplitude 2
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
%         1.	frequency   nu
%         2.	ecl. long.  lam
%         3.	ecl. lat.   bet
%         4.	spin down   d
%         5.	amplitude   A
%         6.	CR (global)
%         7.	Uncertainty on  lam  (semi-interval)
%         8.	Uncertainty on  bet  (semi-interval)
%         9.	h-amplitude

% Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

funt=tic;
coin.start=datestr(now);

inp1=inputname(1);
inp2=inputname(2);
inp3=inputname(3);
inp4=inputname(4);

if isstruct(cand1)
    cand1=cand1.cand;
else
    inp3='??';
end
if isstruct(cand2)
    cand2=cand2.cand;
else
    inp4='??';
end

coin.inpclust1=inp1;
coin.inpclust2=inp2;
coin.inpcand1=inp3;
coin.inpcand2=inp4;

if ~exist('reduce','var')
    reduce=[1 1 1 1];
end
if length(reduce) == 1
    reduce=[reduce 1 1 1];
end

DT=in2.info.run.epoch-in1.info.run.epoch;
delay=DT*86400;

[aa, m1]=size(in1.clust);
[aa, m2]=size(in2.clust);

if exist('m1lim','var')
    m1=m1lim;
    m2=m1lim;
    fprintf('start at %s  (limited)\n',datestr(now))
else
    fprintf('start 0 at %s \n',datestr(now))
end

coin.m1=m1;
coin.m2=m2;

coin.info1=in1.info;
coin.info2=in2.info;
coin.reduce=reduce;

% Uncertanties

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
frdist=dfr*dist;
sddist=dsd*dist;

coin.T1=in1.info.run.epoch;
coin.T2=in2.info.run.epoch;
coin.T0=(1-kepoch)*coin.T1+kepoch*coin.T2;
coin.dist=dist;
coin.kepoch=kepoch;
coin.numer=numer;

% frequency correction and FIRST PERM

[cand1,ind1]=sd_corr(cand1,coin.T1,coin.T0);
index1=in1.index(ind1);
[cand2,ind2]=sd_corr(cand2,coin.T2,coin.T0);
index2=in2.index(ind2);

% statistics

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

% cluster cand sort SECOND PERM
 
[ic0,ia,ic]=unique(index1);
[ic0,ii1]=sort(ic);
ic0d=diff(ic0);
ic0d=[1; ic0d];
ncl=length(ia);
indii1=zeros(2,ncl);
icd=find(ic0d);
indii1(2,:)=[icd(2:length(icd))-1 ; length(ic0d)];
indii1(1,:)=icd;
coin.indii1=indii1;

[ic0,ia,ic]=unique(index2);
[ic0,ii2]=sort(ic);
ic0d=diff(ic0);
ic0d=[1; ic0d];
nc2=length(ia);
indii2=zeros(2,nc2);
icd=find(ic0d);
indii2(2,:)=[icd(2:length(icd))-1 ; length(ic0d)];
indii2(1,:)=icd;
coin.indii2=indii2;

cand1=cand1(ii1,:);
cand2=cand2(ii2,:);
coin.perm1=ind1(ii1);
coin.perm2=ind2(ii2);

sd1min=in1.clust(12,:);
sd1max=in1.clust(13,:);
lam1max=in1.clust(7,:);
lam1min=in1.clust(6,:);
bet1max=in1.clust(10,:);
bet1min=in1.clust(9,:);
dlam1=in1.clust(17,:);
dbet1=in1.clust(18,:);
num1=in1.clust(1,:);

sd2min=in2.clust(12,:);
sd2max=in2.clust(13,:);
lam2max=in2.clust(7,:);
lam2min=in2.clust(6,:);
bet2max=in2.clust(10,:);
bet2min=in2.clust(9,:);
dlam2=in2.clust(17,:);
dbet2=in2.clust(18,:);
num2=in2.clust(1,:);

N=0;
N1=0;
N2=1000;
mm=1;
coinmat=zeros(23,N2);

% new cluster limits

FR1MIN=zeros(1,m1);
FR1MAX=FR1MIN;

for i = 1:m1
    kc1=indii1(1,i):indii1(2,i);
    c1=cand1(kc1,:);
    FR1MIN(i)=min(c1(:,1));
    FR1MAX(i)=max(c1(:,1));
end

FR2MIN=zeros(1,m2);
FR2MAX=FR2MIN;

for i = 1:m2
    kc2=indii2(1,i):indii2(2,i);
    c2=cand2(kc2,:);
    FR2MIN(i)=min(c2(:,1));
    FR2MAX(i)=max(c2(:,1));
end

% cross-limits

MINJ=zeros(1,m1);
MAXJ=MINJ;
nomin=[];
nomax=[];

fr1=(FR1MIN+FR1MAX)/2;
fr2=(FR2MIN+FR2MAX)/2;

jsup=equi_samp(fr1,fr2,1:m1);

for i = 1:m1
    sup2=jsup(i);
    n1=max(1,sup2-elong);
    n2=min(m2,sup2+elong);
    ffmin=FR2MIN(n1:n2);
    ffmax=FR2MAX(n1:n2);
    j1=find(FR1MIN(i) <= ffmax+frdist,1,'first');
    if ~isempty(j1)
        MINJ(i)=j1+n1-1;
    else
        MINJ(i)=m2;
        nomin=[nomin i];
    end
    j1=find(FR1MAX(i)+frdist >= ffmin,1,'last');
    if ~isempty(j1)
        MAXJ(i)=j1+n1-1;
    else
        MAXJ(i)=1;
        nomax=[nomax i];
    end
end

coin.nomin=nomin;
coin.nomax=nomax;

figure,plot(MINJ,'.'),hold on,plot(MAXJ,'r.')
figure,plot(FR1MIN,'.'),hold on,plot(FR1MAX,'r.'),plot(FR2MIN,'g.'),plot(FR2MAX,'k.')

coin.MINJ=MINJ;
coin.MAXJ=MAXJ;
fprintf('start at %s \n',datestr(now))
j=0; % NON TOGLIERE
    
for i = 1:m1   % clusters 1
    if floor(i/10000)*10000 == i
        cl=clock;
        dN=N-N1;
        N1=N;
        fprintf('i,j,mm,fr,N,dN: %d %d %d %f %d %d  %d:%d:%f \n',i,j,mm,FR1MIN(i),N,dN,cl(4:6))
    end
    if num1(i) < numer(1) || num1(i) > numer(2)
        continue
    end
    
    mm=mm+1;

    kc1=indii1(1,i):indii1(2,i);
    c1=cand1(kc1,:);
    ncand1=length(kc1);

    for j = MINJ(i):MAXJ(i)   % clusters 2
        if num2(j) < numer(1) || num2(j) > numer(2)
            continue
        end
        if FR2MIN(j) > FR1MAX(i)+frdist
            continue
        end
        if FR1MIN(i) > FR2MAX(j)+frdist
            continue
        end
        if bet1min(i) > bet2max(j)+dist*(dbet1(i)+dbet2(j))/2
            continue
        end
        if bet2min(j) > bet1max(i)+dist*(dbet1(i)+dbet2(j))/2
            continue
        end
        if lam1max(i)-lam1min(i) < 180 && lam2max(j)-lam2min(j) < 180
            if lam1max(i) <= 180 && lam2max(j) <= 180 || lam1min(i) >= 180 && lam2min(j) >= 180
                lam1=lam1min(i)-lam2max(j);
                dist0=dist*(dlam1(i)+dlam2(j))/2;
                if lam1 > dist0
                    continue
                end
                lam2=lam2min(j)-lam1max(i);
                if lam2 > dist0
                    continue
                end
            end
        end
        if sd1min(i) > sd2max(j)+sddist
            continue
        end
        if sd2min(j) > sd1max(i)+sddist
            continue
        end
         
        kc2=indii2(1,j):indii2(2,j);
        c2=cand2(kc2,:);
%         ncand2=length(kc2);
        dd=[];
        id=0;
            
        for ii = 1:ncand1   % candidates 1
%             [d,jcand]=distance(c1(ii,:),c2,dfr,dsd,reduce);
            const=c1(ii,:);
            Dlam=const(2)-c2(:,2);
            [d, kcand]=min(sqrt(...
                ((const(1)-c2(:,1))/dfr).^2+...
                ((const(4)-c2(:,4))/dsd).^2+...
                (min(mod(Dlam,360),mod(-Dlam,360))./((const(7)+c2(:,7))/reduce(2))).^2+...
                ((const(3)-c2(:,3))./((const(8)+c2(:,8))/reduce(3))).^2 ...
                ));
            if d <= dist
                id=id+1;
                dd(3,id)=ii;
                dd(1,id)=d;
                dd(2,id)=kcand;
            end
        end
        if id > 0
            [d,jj]=min(dd(1,:));
            jcand=dd(2,jj);
            icand=dd(3,jj);
            N=N+1;
            if N > N2
                coinmat(:,N2+1:N2+1000)=zeros(23,1000);
                N2=N2+1000;
            end

            coinmat(1,N)=i;
            coinmat(2,N)=j;
            coinmat(3,N)=icand+indii1(1,i)-1;
            coinmat(4,N)=jcand+indii2(1,j)-1;
            coinmat(5,N)=d;
            coinmat(6:14,N)=c1(icand,:);
            coinmat(15:23,N)=c2(jcand,:);
        end
    end
%     if N > 10
%         break
%     end
end

coin.coin=coinmat(:,1:N);

coin.clust1=in1.clust(:,coinmat(1,1:N));
coin.clust2=in2.clust(:,coinmat(2,1:N));

stat(6,:)=hist((coin.clust1(5,:)+coin.clust1(5,:))/2,hfr);
coin.stat=stat;

comp=computer;
coin.computer=comp;
workdir=pwd;
coin.workdir=workdir;

coin.ftime=toc(funt);


% function [d, kcand]=distance(const,arr,dfr,dsd,reduce)
% 
% Dlam=const(2)-arr(:,2);
% [d, kcand]=min(sqrt(...
%     ((const(1)-arr(:,1))/dfr).^2+...
%     ((const(4)-arr(:,4))/dsd).^2+...
%     (min(mod(Dlam,360),mod(-Dlam,360))./((const(7)+arr(:,7))/reduce(2))).^2+...
%     ((const(3)-arr(:,3))./((const(8)+arr(:,8))/reduce(3))).^2 ...
%     ));


function [cand, ind, DFR]=sd_corr(cand,epoch,epochcoin)

DFR=cand(:,4)*(epochcoin-epoch)*86400;
fr=cand(:,1)+DFR;

[fr, ind]=sort(fr);
cand=cand(ind,:);
cand(:,1)=fr;