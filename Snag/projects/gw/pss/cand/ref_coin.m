function out=ref_coin(coin)
% coincidence refinement
%
%    out=ref_coin(coin)
%
%   out.cref  (min d, cand1, cand2)
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


% Version 2.0 - May 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca
% Department of Physics - Università "Sapienza" - Rome

out=struct();
[dum,N]=size(coin.indcoin);
[n1,dum]=size(coin.cand1);
[n2,dum]=size(coin.cand2);
indcand=coin.indcand; 
indcand(1:2,N+1)=[n1+1,n2+1];
reduce=coin.reduce;
dfr=coin.dfr;
dsd=coin.dsd;
cref=zeros(N,3);

for i = 1:N
    if floor(i/10000)*10000 == i
        disp(i/N)
    end
    c1=coin.cand1(indcand(1,i):indcand(1,i+1)-1,:); %size(c1)
    c2=coin.cand2(indcand(2,i):indcand(2,i+1)-1,:); %size(c2)
%     d=[];
%     imin=[];
    nj=indcand(1,i+1)-indcand(1,i);
    d=zeros(1,nj);
    jmin=d;
    for j = 1:nj;
        [d(j),jmin(j)]=distance(c1(j,:),c2,dfr,dsd,reduce);
    end
    [dmin,imin]=min(d);
    cref(i,:)=[dmin indcand(1,i)+imin-1 indcand(2,i)+jmin(imin)-1];
end

out.cref=cref;



function [d,imin]=distance(const,arr,dfr,dsd,reduce)

[d,imin]=min(sqrt(...
    ((const(1)-arr(:,1))/dfr).^2+...
    ((const(4)-arr(:,4))/dsd).^2+...
    ((const(2)-arr(:,2))./((const(7)+arr(:,7))/reduce(2))).^2+...
    ((const(3)-arr(:,3))./((const(8)+arr(:,8))/reduce(3))).^2 ...
    ));
