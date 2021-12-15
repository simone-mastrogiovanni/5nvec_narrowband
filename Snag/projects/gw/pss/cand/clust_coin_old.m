function [coin,stat]=clust_coin_old(in1,in2,DT,numer,stepstat)
%
%   coin=clust_coin(in1,par1,in2,par2,res)
%
%   in1,in2     input cluster structure array
%   DT          epoch delay (epoch2-epoch1, in days)
%               the output frequencies are computed at epoch1
%   numer       if exist, [min max] numerosity
%   stepstat    frequency step of statistics
%
%   coin    coincidence structure array
%   stat    (6,:) frequency statistics: 1 fr, 2 cand1, 3 clust1, 
%           4 cand2, 5 clust2, 6 coin 

% Version 2.0 - July 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[aa, n1]=size(in1);
[aa, n2]=size(in2);
delay=DT*86400;

if ~exist('stepstat','var')
    stepstat=0.1;
end

if exist('numer','var')
    fprintf('numerosity %d - %d \n',numer)
    num=zeros(1,n1);
    for i = 1:n1
        num(i)=in1(i).num;
    end
    ii=find(num >= numer(1) & num <= numer(2));
    in1=in1(ii);
    n1=length(ii);
    
    num=zeros(1,n2);
    for i = 1:n2
        num(i)=in2(i).num;
    end
    ii=find(num >= numer(1) & num <= numer(2));
    in2=in2(ii);
    n2=length(ii);
    
    fprintf('clusters %d - %d \n',n1,n2)
end

fr1min=zeros(1,n1);
fr1max=fr1min;
lam1max=fr1min;
lam1min=fr1min;
bet1max=fr1min;
bet1min=fr1min;
sd1max=fr1min;
sd1min=fr1min;
num1=fr1min;

for i = 1:n1
    fr1min(i)=in1(i).frmin;
end
[fr1min, ix]=sort(fr1min);
eps=0.001;
band=[floor(fr1min(1)+eps),ceil(fr1min(n1))];

nstat=ceil((band(2)-band(1))/stepstat);
stat=zeros(6,nstat);
stat(1,:)=(0:nstat-1)*stepstat+band(1);
ind1=floor((fr1min-band(1))/stepstat)+1;
iii=find(ind1 < 1);
ind1(iii)=1;
ind1a=1;
iind1a=1;

in1=in1(ix);
for i = 1:n1
    fr1max(i)=in1(i).frmax;
    lam1min(i)=in1(i).lammin;
    lam1max(i)=in1(i).lammax;
    bet1min(i)=in1(i).betmin;
    bet1max(i)=in1(i).betmax;
    sd1min(i)=in1(i).sdmin;
    sd1max(i)=in1(i).sdmax;
    num1(i)=in1(i).num;
    if ind1(i) > ind1a
        ind1a=ind1(i);
        iind1b=i-1;
        ii=floor((fr1min(iind1a)-fr1min(1))/stepstat)+1;
        stat(2,ii)=sum(num1(iind1a:iind1b));
        stat(3,ii)=iind1b-iind1a+1;
        iind1a=i;
    end
end

fr2min=zeros(1,n2);
fr2max=fr2min;
lam2max=fr2min;
lam2min=fr2min;
bet2max=fr2min;
bet2min=fr2min;
sd2max=fr2min;
sd2min=fr2min;
num2=fr2min;

for i = 1:n2
    fr2min(i)=in2(i).frmin-in2(i).sd*delay;
end
[fr2min, ix]=sort(fr2min);
in2=in2(ix);

ind2=floor((fr2min-band(1))/stepstat)+1;
iii=find(ind2 < 1);
ind2(iii)=1;
ind2a=1;
iind2a=1;

for i = 1:n2
    fr2max(i)=in2(i).frmax+in2(i).sd*delay;
    lam2min(i)=in2(i).lammin;
    lam2max(i)=in2(i).lammax;
    bet2min(i)=in2(i).betmin;
    bet2max(i)=in2(i).betmax;
    sd2min(i)=in2(i).sdmin;
    sd2max(i)=in2(i).sdmax;
    num2(i)=in2(i).num;
    if ind2(i) > ind2a
        ind2a=ind2(i);
        iind2b=i-1;
        ii=floor((fr2min(iind2a)-fr2min(1))/stepstat)+1;
        stat(4,ii)=sum(num2(iind2a:iind2b));
        stat(5,ii)=iind2b-iind2a+1;
        iind2a=i;
    end
end

lfr1=max(fr1max-fr1min)
% if lfr1 > 0.1
%     lfr1=0.1
% end
lfr2=max(fr2max-fr2min);

N=0;
N1=0;
coin=struct('clust1',0,'clust2',0,'frmin',0,'frmax',0,'fr',0,...
    'lammin',0,'lammax',0,'lam',0,'dlam',0,...
    'betmin',0,'betmax',0,'bet',0,'dbet',0,...
    'sdmin',0,'sdmax',0,'sd',0,...
    'ampmax',0,'cr',0,'num',0);

j1=1;
j=0;
ind1a=1;
iind1a=1;
Na=0;
    
for i = 1:n1
    if floor(i/1000)*1000 == i
        cl=clock;
        dN=N-N1;
        N1=N;
        fprintf('i,j,fr,N,dN: %d %d %f %d %d  %d:%d:%f \n',i,j,fr1min(i),N,dN,cl(4:6))
    end
    if ind1(i) > ind1a
        ind1a=ind1(i);
        iind1b=i-1;
        ii=floor((fr1min(iind1a)-fr1min(1))/stepstat)+1;
        stat(6,ii)=N-Na;
        Na=N;
        iind1a=i;
    end
    in10=in1(i);
    
    for j = j1:n2
        if fr2min(j)+lfr2 < fr1min(i)
            j1=j+1;
        end
        if fr2min(j) > fr1max(i)
            break
        end
        if secante([fr1min(i) fr1max(i)],[fr2min(j) fr2max(j)]) * ...
                secante([lam1min(i) lam1max(i)],[lam2min(j) lam2max(j)]) * ...
                secante([bet1min(i) bet1max(i)],[bet2min(j) bet2max(j)]) * ...
                secante([sd1min(i) sd1max(i)],[sd2min(j) sd2max(j)]) > 0
            N=N+1;
            coin(N).clust1=in10;
            coin(N).clust2=in2(j);
            coin(N).frmin=max(in10.frmin,in2(j).frmin);
            coin(N).frmax=min(in10.frmax,in2(j).frmax);
            coin(N).fr=(coin(N).frmin+coin(N).frmax)/2;
            coin(N).dfr=(coin(N).frmax-coin(N).frmin)/2;
            coin(N).lammin=max(in10.lammin,in2(j).lammin);
            coin(N).lammax=min(in10.lammax,in2(j).lammax);
            coin(N).lam=(coin(N).lammin+coin(N).lammax)/2;
            coin(N).dlam=(coin(N).lammax-coin(N).lammin)/2;
            coin(N).betmin=max(in10.betmin,in2(j).betmin);
            coin(N).betmax=min(in10.betmax,in2(j).betmax);
            coin(N).bet=(coin(N).betmin+coin(N).betmax)/2;
            coin(N).dbet=(coin(N).betmax-coin(N).betmin)/2;
            coin(N).sdmin=max(in10.sdmin,in2(j).sdmin);
            coin(N).sdmax=min(in10.sdmax,in2(j).sdmax);
            coin(N).sd=(coin(N).sdmin+coin(N).sdmax)/2;
            coin(N).dsd=(coin(N).sdmax-coin(N).sdmin)/2;
            coin(N).corrfr=in2(j).sd*delay;
        end
    end
end


function ii=secante(a,b)

ii=0;
if a(1) >= b(1) && a(1) <= b(2) || ...
        a(2) >= b(1) && a(2) <= b(2) || ...
        b(1) >= a(1) && b(1) <= a(2) || ...
        b(2) >= a(1) && b(2) <= a(2)
    ii=1;
end
    