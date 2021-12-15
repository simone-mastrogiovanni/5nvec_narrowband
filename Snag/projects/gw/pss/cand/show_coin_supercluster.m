function out=show_coin_supercluster(coin,kcoin,rthr)
%
%   out=show_coin_supercluster(coin,kcoin)
%
%   coin      coin structure
%   kcoin     coincidence indices
%   rthr      (2) ratio for the two thresholds (1 normal)
%
%   out.T1     cluster1 epoch
%   out.T2     cluster2 epoch
%   out.T0     coincidence epoch
%   out.cand1  candidates for supercluster 1
%   out.cand2  candidates for supercluster 2
%   out.mat    output of coin_mat on the two superclusters

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('rthr')
    rthr=1;
end
if length(rthr) < 2
    rthr=[rthr rthr];
end
out.T1=coin.T1;
out.T2=coin.T2;
out.T0=coin.T0;
cref=coin.cref;

[dum,N]=size(coin.indcoin);
[n1,dum]=size(coin.cand1);
[n2,dum]=size(coin.cand2);
indcand=coin.indcand; 
indcand(1:2,N+1)=[n1+1,n2+1];
dfr=coin.dfr;
dsd=coin.dsd;
reduce=coin.reduce;

cand_1=[];
cand_2=[];
i1=1;
j1=1;

for i = 1:length(kcoin)
    jj=kcoin(i);
    cand1=coin.cand1(indcand(1,jj):indcand(1,jj+1)-1,:);
    [c1,dum]=size(cand1);
    i2=i1+c1-1;
    cand_1(i1:i2,:)=cand1;
%     [aa,ii1]=max(cand1(:,5));
    i1=i2+1;
    cand2=coin.cand2(indcand(2,jj):indcand(2,jj+1)-1,:);
    [c2,dum]=size(cand2);
    j2=j1+c2-1;
    cand_2(j1:j2,:)=cand2;
%     [aa,ii2]=max(cand2(:,5));
    j1=j2+1;
end

CC1=coin.indcoin(1,kcoin);
CC2=coin.indcoin(2,kcoin);
cc1=cand_1(:,1).*cand_1(:,2).*cand_1(:,3).*cand_1(:,4);
cc2=cand_2(:,1).*cand_2(:,2).*cand_2(:,3).*cand_2(:,4);

fprintf('Group 1: number of clusters   %d   different %d \n',length(CC1),length(unique(CC1)));
fprintf('       : number of candidates %d   different %d \n',length(cc1),length(unique(cc1)));
fprintf('Group 2: number of clusters   %d   different %d \n',length(CC2),length(unique(CC2)));
fprintf('       : number of candidates %d   different %d \n',length(cc2),length(unique(cc2)));

if length(unique(cc1)) > length(unique(cc2))
    figure
    plot(cand_1(:,1),cand_1(:,4),'.'),hold on,grid on,plot(cand_2(:,1),cand_2(:,4),'r.')
    title(sprintf('%d: sd vs f',i))
    figure
    plot(cand_1(:,2),cand_1(:,3),'.'),hold on,grid on,plot(cand_2(:,2),cand_2(:,3),'r.')
    title('bet vs lam')
    figure
    plot(cand_1(:,1),cand_1(:,2),'.'),hold on,grid on,plot(cand_2(:,1),cand_2(:,2),'r.')
    title('lam vs f')
    figure
    plot(cand_1(:,2),cand_1(:,4),'.'),hold on,grid on,plot(cand_2(:,2),cand_2(:,4),'r.')
    title('sd vs lam')
else
    plot(cand_2(:,1),cand_2(:,4),'r.'),hold on,grid on,plot(cand_1(:,1),cand_1(:,4),'.')
    title(sprintf('%d: sd vs f',i))
    figure
    plot(cand_2(:,2),cand_2(:,3),'r.'),hold on,grid on,plot(cand_1(:,2),cand_1(:,3),'.')
    title('bet vs lam')
    figure
    plot(cand_2(:,1),cand_2(:,2),'r.'),hold on,grid on,plot(cand_1(:,1),cand_1(:,2),'.')
    title('lam vs f')
    figure
    plot(cand_2(:,2),cand_2(:,4),'r.'),hold on,grid on,plot(cand_1(:,2),cand_1(:,4),'.')
    title('sd vs lam')
end

[ucc1,ui1]=unique(cc1);
[ucc2,ui2]=unique(cc2);
cand_1=cand_1(ui1,:);
cand_2=cand_2(ui2,:);

[hA1 x1]=hist(cand_1(:,5),100);
[hA2 x2]=hist(cand_2(:,5),100);
figure,stairs(x1,hA1),grid on
hold on,stairs(x2,hA2*max(hA1)/max(hA2),'r')
title('h histograms (equalized)')

if length(unique(cc1)) > length(unique(cc2))
    figure,plot(cand_1(:,5),cand_1(:,9),'.'),grid on
    hold on,plot(cand_2(:,5),cand_2(:,9),'r.')
else
    figure,plot(cand_2(:,5),cand_2(:,9),'r.'),grid on
    hold on,plot(cand_1(:,5),cand_1(:,9),'.')
end
title('h vs A')

clear A
A(:,1)=cand_1(:,1);
A(:,2)=cand_1(:,4);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: sd vs f'))

clear B
B(:,1)=cand_2(:,1);
B(:,2)=cand_2(:,4);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: sd vs f'))

A(:,1)=cand_1(:,2);
A(:,2)=cand_1(:,3);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: bet vs lam'))

B(:,1)=cand_2(:,2);
B(:,2)=cand_2(:,3);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: bet vs lam'))

A(:,1)=cand_1(:,1);
A(:,2)=cand_1(:,2);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: lam vs f'))

B(:,1)=cand_2(:,1);
B(:,2)=cand_2(:,2);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: lam vs f'))

A(:,1)=cand_1(:,2);
A(:,2)=cand_1(:,4);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: sd vs lam'))

B(:,1)=cand_2(:,2);
B(:,2)=cand_2(:,4);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: sd vs lam'))

thresh1=rthr(1)*(max(cand_1(:,5)+min(cand_1(:,5))))/2;
thresh2=rthr(2)*(max(cand_2(:,5)+min(cand_2(:,5))))/2;
i1=find(cand_1(:,5) > thresh1);
cand_1=cand_1(i1,:);
i2=find(cand_2(:,5) > thresh2);
cand_2=cand_2(i2,:);

[dum,I]=sort(cand_1(:,1));
cand_1=cand_1(I,:);
[dum,I]=sort(cand_2(:,1));
cand_2=cand_2(I,:);

out.cand1=cand_1;
out.cand2=cand_2;

fprintf('\nSupercluster 1: %d candidates \n',length(i1));
fprintf('Supercluster 2: %d candidates \n',length(i2));

figure
plot(cand_1(:,1),cand_1(:,4),'.'),hold on,grid on,plot(cand_2(:,1),cand_2(:,4),'r.')
title(sprintf('%d: sd vs f',i))
figure
plot(cand_1(:,2),cand_1(:,3),'.'),hold on,grid on,plot(cand_2(:,2),cand_2(:,3),'r.')
title('bet vs lam')
figure
plot(cand_1(:,1),cand_1(:,2),'.'),hold on,grid on,plot(cand_2(:,1),cand_2(:,2),'r.')
title('lam vs f')
figure
plot(cand_1(:,2),cand_1(:,4),'.'),hold on,grid on,plot(cand_2(:,2),cand_2(:,4),'r.')
title('sd vs lam')

clear A
A(:,1)=cand_1(:,1);
A(:,2)=cand_1(:,4);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: sd vs f'))

clear B
B(:,1)=cand_2(:,1);
B(:,2)=cand_2(:,4);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: sd vs f'))

A(:,1)=cand_1(:,2);
A(:,2)=cand_1(:,3);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: bet vs lam'))

B(:,1)=cand_2(:,2);
B(:,2)=cand_2(:,3);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: bet vs lam'))

A(:,1)=cand_1(:,1);
A(:,2)=cand_1(:,2);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: lam vs f'))

B(:,1)=cand_2(:,1);
B(:,2)=cand_2(:,2);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: lam vs f'))

A(:,1)=cand_1(:,2);
A(:,2)=cand_1(:,4);
A(:,3)=cand_1(:,5);
color_points_1(A),title(sprintf('Group 1: sd vs lam'))

B(:,1)=cand_2(:,2);
B(:,2)=cand_2(:,4);
B(:,3)=cand_2(:,5);
color_points_1(B),title(sprintf('Group 2: sd vs lam'))

out.mat=coin_mat(cand_1,cand_2,dfr,dsd,reduce);

fprintf('\nSupercluster coincidences: \n')
fprintf('close:      %.6f %.2f %.2f %.4e %.4e \n',out.mat.Csour)
fprintf('amp:        %.6f %.2f %.2f %.4e %.4e \n',out.mat.Asour)
fprintf('ampclose:   %.6f %.2f %.2f %.4e %.4e \n',out.mat.CAsour)
fprintf('closeM:     %.6f %.2f %.2f %.4e %.4e \n',out.mat.CsourM)
fprintf('ampM:       %.6f %.2f %.2f %.4e %.4e \n',out.mat.AsourM)
fprintf('ampcloseM:  %.6f %.2f %.2f %.4e %.4e \n',out.mat.CAsourM)

lin1=lin_clust(cand_1,thresh1*0.95);
lin2=lin_clust(cand_2,thresh2*0.95);

figure,plot(lin1.f,lin1.l,'.'),hold on,plot(lin2.f,lin2.l,'r.'),plot(lin1.f,lin1.L,'LineWidth',2)
plot(lin2.f,lin2.L,'r','LineWidth',2),xlabel('fr'),ylabel('lambda'),grid on
figure,plot(lin1.f,lin1.s,'.'),hold on,plot(lin2.f,lin2.s,'r.'),plot(lin1.f,lin1.S,'LineWidth',2)
plot(lin2.f,lin2.S,'r','LineWidth',2),xlabel('fr'),ylabel('spin-down'),grid on
figure,plot(lin1.f,lin1.b,'.'),hold on,plot(lin2.f,lin2.b,'r.'),plot(lin1.f,lin1.B,'LineWidth',2)
plot(lin2.f,lin2.B,'r','LineWidth',2),xlabel('fr'),ylabel('beta'),grid on

out.lin1=lin1;
out.lin2=lin2;

A=[-out.lin1.a_fl(1) 1;-out.lin2.a_fl(1) 1];
B=[out.lin1.a_fl(2);out.lin2.a_fl(2)];
out.X_fl = linsolve(A,B);

A=[-out.lin1.a_fs(1) 1;-out.lin2.a_fs(1) 1];
B=[out.lin1.a_fs(2);out.lin2.a_fs(2)];
out.X_fs = linsolve(A,B);

A=[-out.lin1.a_fb(1) 1;-out.lin2.a_fb(1) 1];
B=[out.lin1.a_fb(2);out.lin2.a_fb(2)];
out.X_fb = linsolve(A,B);

fprintf('    Cluster fits \n')
fprintf('f-lam: %.4f %.1f goodness: %.2f %.2f \n',out.X_fl,out.lin1.wsnr_l,out.lin2.wsnr_l)
fprintf('f-sd : %.4f %.3e goodness: %.2f %.2f \n',out.X_fs,out.lin1.wsnr_s,out.lin2.wsnr_s)
fprintf('f-bet: %.4f %.1f goodness: %.2f %.2f \n',out.X_fb,out.lin1.wsnr_b,out.lin2.wsnr_b)