dx=0.00001;
x=-5:dx:5;

aga=2.5;
ga=exp(-x.^2/(2*aga^2))/(sqrt(2*pi)*aga);
ex=exp(-abs(x))/2;
pa=(25-x.^2)/(500/3);
cu=(125-abs(x.^3));
icu=sum(cu)*dx;
cu=cu/icu;
aca=0.5;
ca=1./(x.^2+aca^2);
ica=sum(ca)*dx;
ca=ca/ica;

figure,plot(x,ga),hold on
plot(x,ex,'k')
plot(x,pa,'r')
plot(x,cu,'g')
plot(x,ca,'m')
grid on

n1=10000;
[ga1,xga1]=hist(ga,n1);
[ex1,xex1]=hist(ex,n1);
[pa1,xpa1]=hist(pa,n1);
[cu1,xcu1]=hist(cu,n1);
[ca1,xca1]=hist(ca,n1);

figure,semilogy(ga1(2:n1-1)),grid on,title('f(1) gaussiana')
figure,semilogy(ex1(2:n1-1)),grid on,title('f(1) esponenziale')
figure,semilogy(pa1(2:n1-1)),grid on,title('f(1) parabola')
figure,semilogy(cu1(2:n1-1)),grid on,title('f(1) gcubica')
figure,semilogy(ca1(2:n1-1)),grid on,title('f(1) Cauchy')


n2=100;
[ga2,xga2]=hist(ga1,n2);
[ex2,xex2]=hist(ex1,n2);
[pa2,xpa2]=hist(pa1,n2);
[cu2,xcu2]=hist(cu1,n2);
[ca2,xca2]=hist(ca1,n2);

figure,loglog(ga2(2:n2-1)),hold on,loglog(ga2(2:n2-1),'r+'),grid on,title('f(2) gaussiana')
figure,loglog(ex2(2:n2-1)),hold on,loglog(ex2(2:n2-1),'r+'),grid on,title('f(2) esponenziale')
figure,loglog(pa2(2:n2-1)),hold on,loglog(pa2(2:n2-1),'r+'),grid on,title('f(2) parabola')
figure,loglog(cu2(2:n2-1)),hold on,loglog(cu2(2:n2-1),'r+'),grid on,title('f(2) cubica')
figure,loglog(ca2(2:n2-1)),hold on,loglog(ca2(2:n2-1),'r+'),grid on,title('f(2) Cauchy')

