function [d,dd,h,hh,xh]=clust_distance(cand1,cand2,coin)
% inter-clusters distances
%
%    d=clust_distance(cand1,cand2)
%
%  cand1,cand2   clusters candidates matrices (as created by clusts_from_coin)

% Snag version 2.0 - January 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n1,dum]=size(cand1);
[n2,dum]=size(cand2);
N=n1*n2;

d=zeros(1,N);
dd=zeros(4,N);
ddd=zeros(3,N);
d1=zeros(1,n1^2);
d2=zeros(1,n2^2);
dfr=coin.dfr;
dsd=coin.dsd;

for i = 1:n1
    [d((i-1)*n2+1:i*n2),dd(1,(i-1)*n2+1:i*n2),dd(2,(i-1)*n2+1:i*n2),dd(3,(i-1)*n2+1:i*n2),dd(4,(i-1)*n2+1:i*n2)]=...
        distance_4(cand1(i,:),cand2,dfr,dsd);
end

ddd(1,:)=sqrt(dd(1,:).^2+dd(2,:).^2);
ddd(2,:)=sqrt(dd(1,:).^2+dd(4,:).^2);
ddd(3,:)=sqrt(dd(2,:).^2+dd(3,:).^2);

nh=round(sqrt(N));

[h,xh]=hist(d,nh);

figure,stairs(xh,h);grid on,title('Distance histogram')

figure,loglog(xh,h),grid on,title('Distance histogram')
hold on,loglog(xh,h,'r.')

[hh,xh]=hist(dd',nh);
[hhh,xh]=hist(ddd',nh);

figure,stairs(xh,hh);grid on
legend('frequency','lambda','beta','spin-down'),title('Partial distance histograms')

figure,loglog(xh,hh),grid on
legend('frequency','lambda','beta','spin-down'),title('Partial distance histograms')

figure,stairs(xh,hhh);grid on
legend('frequency+lambda','frequency+spin-down','lambda+beta'),title('Partial distance histograms')

figure,loglog(xh,hhh),grid on
legend('frequency+lambda','frequency+spin-down','lambda+beta'),title('Partial distance histograms')

for i = 1:n1
    d1((i-1)*n1+1:i*n1)=distance_4(cand1(i,:),cand1,dfr,dsd);
end

for i = 1:n2
    d2((i-1)*n2+1:i*n2)=distance_4(cand2(i,:),cand2,dfr,dsd);
end

nh1=round(sqrt(n1^2));
[h1,xh1]=hist(d1,nh1);

nh2=round(sqrt(n2^2));
[h2,xh2]=hist(d2,nh2);

figure,stairs(xh,h);grid on,title('Distance and self-distance histogram')
hold on,stairs(xh1,h1,'r'),stairs(xh2,h2,'g')

figure,loglog(xh,h),grid on,title('Distance and self-distance histogram')
hold on,loglog(xh,h,'r.'),loglog(xh1,h1,'r'),loglog(xh1,h1,'.'),loglog(xh2,h2,'g'),loglog(xh2,h2,'.')