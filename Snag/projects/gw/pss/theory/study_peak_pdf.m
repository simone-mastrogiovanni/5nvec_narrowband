% study_peak_pdf

dx=0.01;
x=dx:dx:100;
nsig=10;
dsig=2;
mu=(1:nsig)*0;
mu1=mu;
sig=mu;
a=mu;

c1=2/3;

figure

for i = 1:nsig
    sig(i)=(i-1)*dsig;
    y1=2*ncx2pdf(2*x,2,2*sig(i)); sum(y1)*dx;
    y=y1.*((1-exp(-x)).^2)/(1-c1.^(1+sig(i))); a(i)=sum(y)*dx;
%     y=y1.*(1-exp(-x)).^2; a(i)=sum(y)*dx;
    plot(x,y1,'r'),hold on,grid on
    plot(x,y,'b'),hold on,grid on
    
    mu(i)=sum(x.*y)*dx;
    mu1(i)=sum(x.*y1)*dx;
end

figure
plot(sig,a)
figure
semilogy(sig,a)
figure
plot(sig,mu)
figure
plot(sig,mu1)
