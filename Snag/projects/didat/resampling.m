% resampling : campionamento a 4000 e 4096

f1=4000;
f2=4096;
f0=f2*125;

N=f0*4;
N4=N/(2*128)
y=randn(1,N);
y=fft(y);
y(N4+1:N-N4+1)=0;
M=10;
NM=N4-M
y(NM:N4)=y(NM:N4).*(M:-1:0)/M;
y(N+2-NM:-1:N+2-N4)=conj(y(NM:N4));
y=ifft(y);

y1=y(1:128:N);
y2=y(1:125:N);

x=(1:N)/f0;
x1=x(1:128:N);
x2=x(1:125:N);
figure
plot(x1,y1),hold on,plot(x2,y2,'r'),plot(x,y,'g'),grid on;
figure
plot(x1,y1),hold on,plot(x2,y2,'r'),grid on;

yy1=abs(fft(y1));
yy2=abs(fft(y2));
f1=(0:length(yy1)-1)*f1/length(yy1);
f2=(0:length(yy2)-1)*f2/length(yy2);
figure,semilogy(f1,yy1),hold on,semilogy(f2,yy2,'r'),grid on;