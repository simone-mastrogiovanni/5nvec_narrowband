% sim_pss_multi_coin

n=4;
dx=0.01;
x=-5:dx:6;
N=length(x);
ga=exp(-x.^2/2)/sqrt(2*pi);
faga=cumsum(ga(N:-1:1))*dx;
faga=faga(N:-1:1);
coi=zeros(N,n);
dcoi=zeros(N-1,n);
gcoi=coi;

for i = 1:n
    coi(:,i)=faga.^i;%max(coi(:,i))
    dcoi(:,i)=-diff(coi(:,i))/dx;
    gcoi(:,i)=faga'./coi(:,i);
    mu(i)=sum(dcoi(:,i).*x(1:N-1)')*dx;
    qu(i)=sum(dcoi(:,i).*x(1:N-1)'.^2)*dx;
end

sig=sqrt(qu-mu.^2);mu,sig
figure,semilogy(x(1:N-1),dcoi'),grid on
n1=ceil(N*3/11);
n2=ceil(N*10/11);
coi=coi(n1:n2,:);
gcoi=gcoi(n1:n2,:);
figure,semilogy(x(n1:n2),coi'),grid on

figure,semilogy(x(n1:n2),gcoi'),grid on

% NO LOSS FALSE ALARM

col=get(gca,'ColorOrder');
figure,semilogy(x(n1:n2),faga(n1:n2)),grid on, hold on

for i = 2:n
    x1=x*sqrt(i);
    semilogy(x1(n1:n2),coi(:,i),'Color',col(i,:));
end