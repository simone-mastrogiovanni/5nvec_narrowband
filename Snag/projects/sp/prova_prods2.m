% prova_prods2

N=1000000;
n=20;

a=prp_logunif(N,0.001,1000);
dx=0.01;

x=0/2:dx:ceil(1/dx);

h=hist(a,x);

figure,loglog(x,h),grid on,hold on
th=1./x(2:length(x));
sth=sum(th);
N1=sum(h(2:(length(h)-2)));
th=th*N1/sth;
loglog(x(2:length(x)),th,'r')
figure,loglog(x,h.*x),grid on

la=log(a);
lx=-30:0.1:30;
lh=hist(la,lx);
figure,semilogy(lx,lh),grid on,hold on
sig=std(la)
% tlh=exp(-(lx.^2)/(2*sig^2))./(sqrt(2*pi)*sig);
% stlh=sum(tlh);
% tlh=tlh*N/stlh;
% semilogy(lx,tlh,'r')
