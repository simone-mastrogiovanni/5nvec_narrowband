%Distribuzione uniforme e derivate per convoluzione

dx=0.001;
x=-4:dx:4;
nn=length(x);
nn2=floor(nn/2);
y0=zeros(nn,1);
n=floor(1/(2*dx));
y0(nn/2-n:nn/2+n)=1;
ss=sum(y0)*dx;
y0=y0/ss;length(y0)
y1=conv(y0,y0)*dx;
y1=y1(nn2+1:nn2+nn);
y2=conv(y1,y0)*dx;
y2=y2(nn2+1:nn2+nn);
y3=conv(y2,y0)*dx;
y3=y3(nn2+1:nn2+nn);
y4=conv(y3,y0)*dx;
y4=y4(nn2+1:nn2+nn);
figure
plot(x,y0,'k'),hold on,grid on, zoom on
plot(x,y1,'b')
plot(x,y2,'g')
plot(x,y3,'r')

figure
semilogy(x,y0,'k'),hold on,grid on, zoom on
semilogy(x,y1,'b')
semilogy(x,y2,'g')
semilogy(x,y3,'r')

figure
sig2=4/12;
semilogy(x/sqrt(sig2),y3,'b'), hold on, grid on, zoom on
y=(1/sqrt(2*pi*sig2))*exp(-x.^2/(2*sig2));
semilogy(x/sqrt(sig2),y,'r');