% flatcos_nowindow 

sf=256;
T=1024;
fr0=100;
fi0=0;
dt=1/sf;
dfr=1/T;
n=round(T/dt);
enh=20;  fr0=fr0+dfr/2

dfr0=1/(T*fr0);
wb=1; % intero
wb=5
dfr0max=wb*dfr0;


%----------------------- costante

nois=randn(1,n);
sig=sin((0:n-1)*dt*2*pi*fr0);

Nois=abs(fft(nois)).^2/n;mean(Nois)
Noisw=abs(fft(pswindow('flatcos',n).*nois)).^2/n;
Sig=abs(fft(sig)).^2/n;mean(Noisw)
[A,ii]=max(Sig)
fr=(0:n-1)*dfr;

figure,semilogy(fr,Nois),grid on
figure,semilogy(fr,Sig),grid on

for i = 1:4*enh+1
    sig=sin((0:n-1)*dt*2*pi*(fr0+(i-2*enh)*dfr/enh));
    Sig1=abs(fft(sig)).^2/n;
    Sig1w=abs(fft(pswindow('flatcos',n).*sig)).^2/n;
    A1(i)=Sig1(ii);
    A1w(i)=Sig1w(ii);
end

figure,plot(-2*enh:2*enh,A1),grid on
hold on,plot(-2*enh:2*enh,A1w,'r')

figure,semilogy(-2*enh:2*enh,A1),grid on
hold on,semilogy(-2*enh:2*enh,A1w,'r')


am=max(A1)/max(A1w)

figure,plot(-2*enh:2*enh,A1),grid on
hold on,plot(-2*enh:2*enh,A1w*am,'r')

figure,semilogy(-2*enh:2*enh,A1),grid on
hold on,semilogy(-2*enh:2*enh,A1w*am,'r')

%--------------------- chirp

res=100*wb;

t=(0:n-1)*dt;
c2=(dfr0max*(-res:res)/res);
c2n=c2/dfr0;
nc=length(c2);
for i = 1:nc
    fi=2*pi*(fr0*t+c2(i)*t.^2/2);
    sig=sin(fi);
    Sig1=abs(fft(sig)).^2/n;
    Sig1w=abs(fft(pswindow('flatcos',n).*sig)).^2/n;
    [B1(i),b1(i)]=max(Sig1);
    [B1w(i),b1w(i)]=max(Sig1w);
end

figure,plot(c2n,B1),grid on
hold on,plot(c2n,B1w,'r')
xlabel('normalized spin-down')
title('blue no window, red flatcos')

figure,semilogy(c2n,B1),grid on
hold on,semilogy(c2n,B1w,'r')
xlabel('normalized spin-down')
title('blue no window, red flatcos')

figure,plot(c2n,b1-b1(1)),grid on
hold on,plot(c2n,b1w-b1w(1),'r')

bm=max(B1)/max(B1w)

figure,plot(c2n,B1),grid on
hold on,plot(c2n,B1w*bm,'r')

figure,plot(c2n,B1./B1w),grid on
xlabel('normalized spin-down')
title('nowindow/flatcos')
