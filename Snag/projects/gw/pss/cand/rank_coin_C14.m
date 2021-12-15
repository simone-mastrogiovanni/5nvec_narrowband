function out=rank_coin_C14(coin,sbw,M)
% coincidence selection based on amplitude ranks
%
%    out=rank_coin_C14(coin,dfr)
%
%  coin   coin C14 structure
%  sbw    sub-band width (Hz; def 0.1)
%  M      number of reshuffling; if M < 0, shifting, not reshuffling
%
%  out.fr
%     .N
%     .R
%     .P
%     .sel
%     .Sour
%     .r1
%     .r2
%     .Psim
%
% Sour :
%    1.   frequency
%    2.   lambda
%    3.   beta
%    4.   spin-down
%    5.   h
%    6.   P
%    7.   N
%    8.   R
%    9.   A1
%   10.   A2
%   11.   h1
%   12.   h2
%   13.   n1
%   14.   n2
%   15.   dlam
%   16.   dbet
%   17.   absolute rank 1
%   18.   absolute rank 2
%   19.   mean absolute rank
%   20.   distance
%   21.   clust1
%   22.   cand1
%   23.   clust2
%   24.   cand2
%   25    coincidence number

% Version 2.0 - August 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('sbw','var')
    sbw=0.1;
end
if ~exist('M','var')
    M=20;
end
icresh=1;
if M < 0
    M=-M;
    icresh=0;
end

minN=50;

fr0=coin.stat(1,:);
dfr0=fr0(2)-fr0(1);
frmin=fr0(1)-dfr0/2;
frmax=fr0(length(fr0))+dfr0/2;

[fr,lam,bet,sd,A,h,d,num,dlam,dbet,clusts,cands]=extr_coin_C14(coin);

A1=A(1,:);
f1=fr(1,:);
n1=num(1,:);
h1=h(1,:);
l1=lam(1,:);
b1=bet(1,:);
sd1=sd(1,:);
dl1=dlam(1,:);
db1=dbet(1,:);
cl1=clusts(1,:);
can1=cands(1,:);

A2=A(2,:);
f2=fr(2,:);
n2=num(2,:);
h2=h(2,:);
l2=lam(2,:);
b2=bet(2,:);
sd2=sd(2,:);
dl2=dlam(2,:);
db2=dbet(2,:);
cl2=clusts(2,:);
can2=cands(2,:);

% A1=coin.cand1(coin.cref(:,2),5);
% A2=coin.cand2(coin.cref(:,3),5);
% f1=coin.cand1(coin.cref(:,2),1); 
% f2=coin.cand2(coin.cref(:,3),1);
% 
% n1=coin.clust1(1,:);
% n2=coin.clust2(1,:);
% h1=coin.cand1(coin.cref(:,2),9);
% h2=coin.cand2(coin.cref(:,3),9);
% l1=coin.cand1(coin.cref(:,2),2);
% l2=coin.cand2(coin.cref(:,3),2);
% b1=coin.cand1(coin.cref(:,2),3);
% b2=coin.cand2(coin.cref(:,3),3);
% sd1=coin.cand1(coin.cref(:,2),4);
% sd2=coin.cand2(coin.cref(:,3),4);
% dl1=coin.cand1(coin.cref(:,2),7);
% dl2=coin.cand2(coin.cref(:,3),7);
% db1=coin.cand1(coin.cref(:,2),8);
% db2=coin.cand2(coin.cref(:,3),8);
    
n=ceil((frmax-frmin)/sbw);
N=zeros(n,1);
sel=zeros(n,2);
sel(1:n,2)=frmin;
P=ones(n,1);
R=zeros(n,1);
Psim=zeros(n,M);
fr=zeros(n,1);
h=fr;
ra1=zeros(n,1);
ra2=zeros(n,1);
ra0=zeros(n,1);
Sour=zeros(n,25);

fr1=frmin;
i=0;

while fr1 < frmax-sbw/2
    i=i+1;
    fr(i)=fr1+sbw/2;
    fr2=fr1+sbw;
    ii=find(f1 >= fr1 & f1 < fr2);
    N(i)=length(ii);
    if N(i) >= minN
        [r1,ir1]=sort(A1(ii),'descend');
        [r2,ir2]=sort(A2(ii),'descend');
        r1(ir1)=(1:N(i))/N(i);
        r2(ir2)=(1:N(i))/N(i);
        [P(i),imin]=min(r1.*r2);
        ra1(i)=round(r1(imin)*N(i));
        ra2(i)=round(r2(imin)*N(i));
        ra0(i)=(ra1(i)+ra2(i))/2;
        if icresh == 1
            for j = 1:M
                Psim(i,j)=min(r1.*r2(randperm(N(i))));
            end
        else
            isig=1;
            for j = 1:M
                isig=-isig;
                Psim(i,j)=min(r1.*rota(r2,isig*round((j+1)/2)));
            end
        end
        a=corrcoef(r1,r2);
        R(i)=a(1,2);
        iii=ii(imin);
        h(i)=(h1(iii)+h2(iii))/2;
        sel(i)=iii;
        Sour(i,:)=[(f1(iii)+f2(iii))/2 (l1(iii)+l2(iii))/2  (b1(iii)+b2(iii))/2 ...
           (sd1(iii)+sd2(iii))/2 (h1(iii)+h2(iii))/2  P(i) N(i) R(i) ...
           A1(iii) A2(iii) h1(iii) h2(iii) n1(iii) n2(iii) (dl1(iii)+dl2(iii))/2 ...
           (db1(iii)+db2(iii))/2 ra1(i) ra2(i) ra0(i) d(iii) cl1(iii) can1(iii) cl2(iii) can2(iii) iii];
    end
    fr1=fr2;
end

% n=i; % attention
ii=find(N >= minN);
out.fr=fr(ii);
out.N=N(ii);
out.R=R(ii);
out.P=P(ii);
out.sel=sel(ii,:);
out.Sour=Sour(ii,:);
out.r1=r1;
out.r2=r2;
out.Psim=Psim(ii,:);
out.h=h(ii);