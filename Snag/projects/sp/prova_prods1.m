% prova_prods1

N=1000000;
n=20;

a=prp_buf(N,0,n);
dx=0.005;

x=0:dx:ceil(1/dx);length(x)

h=hist(a,x);

figure,loglog(x,h),grid on,hold on
th=1./x(2:length(x));
sth=sum(th);
N1=sum(h(2:(length(h)-2)));
th=th*N1/sth;
loglog(x(2:length(x)),th,'r')
figure,loglog(x,h.*x),grid on

la=log(a);
lx=(-300:300)*sqrt(n)/30;
lh=hist(la,lx);
figure,semilogy(lx,lh),grid on,hold on
sig=std(la)
tlh=exp(-(lx.^2)/(2*sig^2))./(sqrt(2*pi)*sig);
stlh=sum(tlh);
tlh=tlh*N/stlh;
semilogy(lx,tlh,'r')

figure,loglog(exp(lx),lh./exp(lx)),grid on
