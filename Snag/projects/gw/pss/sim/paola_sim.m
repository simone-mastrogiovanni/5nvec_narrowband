% paola_sim
%
% statistiche peak map

N=100000;

a=0:0.1:10;
na=length(a);
peak=zeros(na,N);

for i = 1:na
    r=randn(6,N);
    nois1=r(1,:).^2+r(2,:).^2;
    nois2=r(3,:).^2+r(4,:).^2;
    sign=(r(5,:)+a(i)*sqrt(2)).^2+r(6,:).^2;
    ii=find(sign > nois1 & sign >= nois2);
    peak(i,ii)=sign(ii)/2;
    npeak(i)=length(ii)/N;
end

figure,plot(a,npeak),grid on
% figure,plot(peak','.'),grid on

amax=max(peak(:));
x=0:0.1:amax;
nx=length(x);
h=zeros(na,nx);
figure

for i = 1:5:na
    ii=find(peak(i,:));
    h(i,:)=hist(peak(i,ii),x);
    stairs(x,h(i,:)),grid on,pause(1)
end

figure,stairs(x,h'),grid on

figure,stairs(x,h(1,:)),grid on,xlim([0,10])

figure,plot(a,sum(peak')/N),grid on
figure,loglog(a,sum(peak')/N),grid on,hold on,loglog(a,sum(peak')/N,'r.')