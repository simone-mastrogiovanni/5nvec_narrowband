n=30;
x=randn(1,n);
y=randn(1,n);

a1=4;b1=10; c1=4;d1=3;e1=0;

x1=a1*x+b1;
y1=c1*x+d1*y+e1;

figure
plot(x1,y1,'b+');hold on; grid on;
corrcoef(x1,y1)

a2=4;b2=10; c2=-4;d2=3;e2=5;

x2=a2*x+b2;
y2=c2*x+d2*y+e2;

plot(x2,y2,'gX');hold on; grid on;
corrcoef(x2,y2)

a3=1;b3=10; c3=0;d3=3;e3=20;

x3=a3*x+b3;
y3=c3*x+d3*y+e3;

plot(x3,y3,'ko');hold on; grid on;
corrcoef(x3,y3)