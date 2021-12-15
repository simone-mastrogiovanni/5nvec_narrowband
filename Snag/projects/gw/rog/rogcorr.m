M=20000;
n=8;
cor=zeros(M,1);cor1=cor;

for i = 1:M
x=(randn(n,1).^2+randn(n,1).^2)./2;
y=(randn(n,1).^2+randn(n,1).^2)./2;
x1=randn(n,1);
y1=randn(n,1);
a=corrcoef(x,y);
cor(i)=a(1,2);
a=corrcoef(x1,y1);
cor1(i)=a(1,2);
end

mean(cor),std(cor)
mean(cor1),std(cor1)

figure
x=(-100:100)*0.01;
m=hist(cor,x)/M;
plot(x,m);hold on;grid on;
n=hist(cor1,x)/M;
plot(x,n,'r'); hold off;

figure
m=(1-cumsum(m));
semilogy(x,m);hold on;grid on;
n=(1-cumsum(n));
semilogy(x,n,'r'); hold off;
