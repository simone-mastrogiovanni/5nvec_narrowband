% rita_ss

dt0=0.001;
fr0=22.34;
fi0=30*pi/180;
N0=1000000;
T0=0;
delay=0.53452
t0=(0:N0-1)*dt0;
% y0=exp(1i*(fr0*(t0-T0)*2*pi+fi0));
y0=exp(1i*(fr0*(t0-T0)*2*pi+fi0));
dfr=1/(N0*dt0)

basei=ceil(22/dfr)
basefr=(basei-1)*dfr
bandi=round(1/dfr)

Y=fft(y0);
Y1=Y(basei:basei+bandi);
X1=Y1;
X1(basei+bandi+2:2*(basei+bandi+1))=0;
N1=length(X1)
x1=ifft(X1)*N1/N0;
dt1=dt0*N0/N1
t1=(0:N1-1)*dt1;

z1=fd_delay(x1,dt1,delay,basefr);

figure,plot(t1,x1),hold on,grid on,plot(t1,z1,'r')

Z1=fft(z1);
Z0(basei:basei+bandi)=Z1(1:bandi+1);
Z0(basei+bandi+2:N0)=0;
z0=ifft(Z0)*N0/N1;
figure,plot(t0,y0),hold on,grid on,plot(t0,z0,'r')
