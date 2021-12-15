n=50;
x=rand(1,n);
y=randn(1,n);

a1=6;b1=0; c1=1;d1=10;e1=0;

x1=a1*x+b1;
y1=c1*x1.^3+d1*y;

figure
plot(x1,y1,'b+');hold on; grid on;
corrcoef(x1,y1)

a2=6.28;b2=0; c2=0;d2=0.1;e2=5;

x=rand(1,3*n);
y=randn(1,3*n);
x2=cos(a2*x);
y2=sin(a2*x)+d2*y;

figure
plot(x2,y2,'bX');hold on; grid on;
corrcoef(x2,y2)

a3=1;b3=10; c3=3;d3=2;e3=20;

n=30;
x=rand(1,n);
y=randn(1,n);
x3=a3*x+b3;
y3=c3*x+d3*y+e3;

x3(n+1:2*n)=a3*x+b3/3;
y3(n+1:2*n)=-c3*x+d3*y+e3/3;

figure
plot(x3,y3,'ko');hold on; grid on;
corrcoef(x3,y3)