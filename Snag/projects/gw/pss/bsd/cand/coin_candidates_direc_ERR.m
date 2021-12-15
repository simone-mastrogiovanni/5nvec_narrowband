function [coin,cand_sel1,cand_sel2]=coin_candidates_direc(in1,in2,cand1,cand2,dist,kepoch)
%
%   coin=coin=coin_candidates(in1,in2,cand1,cand2,dist,kepoch,reduce)
%
%   in1,in2     input cluster structures
%               the output frequencies are computed at epoch defined by kepoch
%      .clust   (18,M)
%   cand1,cand2 candidate matrices (N,9)
%   dist        coincidence distance
%   kepoch      coincidence epoch parameter (0 -> T1, 1 -> T2, other in (0,1)
%               (for VSR2-VSR4 1 is suggested)
%   reduce      metrics reducer factors (>1; [fr,lam,bet,sd] or only fr;
%   def [1 1 1 1])
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
%     .cand1    coincidence candidates
%     .cand2    coincidence  candidates
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

% Version 2.0 - Nov 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sabrina D??ntonio - sabrina.dantonio@roma1.infn.it
% Department of Physics - Universit??? "Sapienza" - Rome
cand_sel1=[];
cand_sel2=[];
D=[];
coin.start=datestr(now);
funtot=tic;
% inp1=inputname(1);
% inp2=inputname(2);


if isstruct(cand1)
    cand1=cand1.cand; % SABRINA qui da decidere se mettiamo dentro cand1 di input tutto o solo i cand
else
    inp3='??';
end
if isstruct(cand2)
    cand2=cand2.cand;
else
    inp4='??';
end

%coin.SoftInj=SI; %sabrina
coin.inpcand1=inp3;
coin.inpcand2=inp4;

if ~exist('reduce','var')
    reduce=[1 1 1 1];
end
if length(reduce) == 1
    reduce=[reduce 1 1 1];
end

%DT=in2.info.run.epoch-in1.info.run.epoch;
DT=in2.epoch-in1.epoch;   %epoch
delay=DT*86400;


ufr1=in1.dfr/2  %dfr ovvero 1/tfft
ufr2=in2.dfr/2
frdist=dist*(ufr1+ufr2);
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
coin.T1=in1.epoch;
coin.T2=in2.epoch;
coin.T0=(1-kepoch)*coin.T1+kepoch*coin.T2;
coin.dist=dist;
coin.kepoch=kepoch;


% frequency correction and FIRST PERM

[cand1,ind1]=sd_corr(cand1',coin.T1,coin.T0);

[cand2,ind2]=sd_corr(cand2',coin.T2,coin.T0);


[ncand1 dmp]=size(cand1) %SABRI
[ncand2 dmp]=size(cand2)


% limit for the coincideces candidates ordered in frequency

[cand10 iis1]=sort(cand1(:,1));
cand10=cand1(iis1,:);


[cand20 iis2]=sort(cand2(:,1));
cand20=cand2(iis2,:);
cand1=cand10;
cand2=cand20;
clear cand10 cand20

% JMAX(j) and JMIN(j) : for the candidate j (1st data set) min and max
% index of the candidates (2nd data set )  to be considered for
% coincidences

JMAX(1:ncand1)=1;%ncand2; max index of the candidate for the 2nd data set to be
JMIN(1:ncand1)=ncand2;
k=1;
for j=1:ncand1
    while cand2(k,1)<cand1(j,1)+frdist & k<ncand2
        k=k+1;
    end
    JMAX(j)=k;
    if k==ncand2
        JMAX(j:ncand1)=k;
        break
    end
end
k
k=ncand2;
for j=ncand1:-1:1
    while cand2(k,1)>cand1(j,1)-frdist & k>1
        k=k-1;
    end
    JMIN(j)=k;
    if k==1
        JMIN(1:j)=k;
        break
    end
end

Nc=0;
for ii = 1:ncand1   % loop over candidates of the first cluster
    const=cand1(ii,:);
    c2=cand2(JMIN(ii):JMAX(ii),:);
    Dlam=const(2)-c2(:,2);
    [d]=(sqrt(...
        ((const(1)-c2(:,1))/dfr).^2+...
        ((const(4)-c2(:,4))/dsd).^2+...
        (min(mod(Dlam,360),mod(-Dlam,360))./((const(7)+c2(:,7))/reduce(2))).^2+...
        ((const(3)-c2(:,3))./((const(8)+c2(:,8))/reduce(3))).^2 ...
        ));
    hd=find(d<=dist);
    if length(hd) >=1   
       for j=1:length(hd)
           cand_sel1=[cand_sel1 const'];
          
       end
       cand_sel2=[cand_sel2 c2(hd,:)'];
        D=[D d(hd)'];
%         cand_sel1(1+Nc:Nc+length(hd),1:9)=const+cand_sel1(1+Nc:Nc+length(hd),1:9);
%         cand_sel2(1+Nc:Nc+length(hd),:)=c2(hd,:);
%         D(1+Nc:Nc+length(hd))=d(hd);
        Nc=Nc+length(hd);
    end
    if floor(ii/100000)*100000 == ii
        ii
        ncand1-ii      
    end
end
%cand_sel2=cand_sel2';
size(cand_sel1)
size(cand_sel2)
coin.cand1=cand_sel1;
coin.cand2=cand_sel2;
coin.d=D;
%clear cand_sel*
clear coinmat

return
%%%warning%%
%return

% workdir=pwd;
% coin.workdir=workdir;
% coin.ftime=toc(funtot);
cand=(coin.cand1(1:9,:)+coin.cand2(1:9,:))/2;
Dist_L=cand(2,:) - coin.cand1(15,:);  %ecliptical LON
if Dist_L >= 360
    Dist_L=Dist_L-360;
end
Dist_LAT=cand(3,:) -coin.cand1(16,:) ;  %ecliptical LAT
coin.distCSI = sqrt(((cand(4,:)-coin.cand1(14,:))/in1.dsd).^2 + ((cand(1,:)-coin.cand1(19,:))/(in1.dfr)).^2 + ((Dist_L)./cand(7,:)).^2 +  ((Dist_LAT)./cand(8,:)).^2);




function [cand ind]=sd_corr(cand,epoch,epochcoin)

fr=cand(:,1)+cand(:,4)*(epochcoin-epoch)*86400;
[fr ind]=sort(fr);
cand=cand(ind,:);
cand(:,1)=fr;