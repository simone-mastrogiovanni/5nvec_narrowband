function show_clust_par(PAR,classlim)
%
%      show_clust_par(PAR,classlim)
%
%   PAR        cluster parameters as created by ana_sel_coin
%   classlim   limits of classes of numerosities (def [2 10 1000000]: two classes)
%

if ~exist('classlim','var')
    classlim=[2 10 1000000];
end
classlim(1)=max(classlim(1),2);
nclass=length(classlim)-1;

for i = 1:nclass
    ii=find(PAR(:,1) >= classlim(i) & PAR(:,1) < classlim(i+1));
    [h1 x1]=hist(PAR(ii,1),200);
    [h2 x2]=hist(PAR(ii,2),200);
    [h3 x3]=hist(PAR(ii,3),200);
    [h4 x4]=hist(PAR(ii,4),200);
    [h5 x5]=hist(PAR(ii,5),200);
    [h6 x6]=hist(PAR(ii,6),200);
    [h7 x7]=hist(PAR(ii,7),200);
    [h8 x8]=hist(PAR(ii,8),200);
    [h9 x9]=hist(PAR(ii,9),200);
    [h10 x10]=hist(PAR(ii,10),200);
    [h11 x11]=hist(PAR(ii,11),200);
    
    str=sprintf(' (numer. %d - %d)',classlim(i),classlim(i+1))
    figure,stairs(x1,log10(h1)),title(['numerosity histogram' str])
    figure,stairs(x2,h2),title(['frequency histogram' str])
    figure,stairs(x3,h3),title(['lambda histogram' str])
    figure,stairs(x4,h4),title(['beta histogram' str])
    figure,stairs(x5,h5),title(['spin-down histogram' str])
    figure,stairs(x6,h6),title(['corr fr-lam, fr-bet, fr-sd' str])
    hold on,stairs(x7,h7,'r')
    hold on,stairs(x8,h8,'g')
    figure,stairs(x9,h9),title(['corr lam-bet, lam-sd' str])
    hold on,stairs(x10,h10,'r')
    figure,stairs(x11,h11),title(['corr bet-sd' str])
end