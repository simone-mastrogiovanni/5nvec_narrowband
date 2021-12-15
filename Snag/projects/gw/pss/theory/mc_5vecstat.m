% mc_5vecstat montecarlo for 5-vector statistics

N=1000000;

r=randn(5,N)+1j*randn(5,N);
rr=abs(r(1,:)).^2;

for i = 2:5
    rr=rr+abs(r(i,:)).^2;
end

for i = 1:5
    r(i,:)=r(i,:)./sqrt(rr);
end

dx=0.005;
x=(dx/2:dx:1);
h1=hist(abs(r(1,:)).^2,x)./(N*dx);
y=4*(1-x).^3;

figure,plot(x,h1),grid on,hold on,plot(x,y,'r--')

r2(:,1)=abs(r(1,:)).^2;
r2(:,2)=abs(r(2,:)).^2;
h2=hist3(r2,[50 50]);

x2=(0.5:50)/50;
figure,image(x2,x2,h2,'CDataMapping','scaled')

r12=r2(:,1)+r2(:,2);
h12=hist(r12,x)./(N*dx);

y12=12*x.*(1-x).^2;

figure,plot(x,h12),grid on,hold on,plot(x,y12,'r--')