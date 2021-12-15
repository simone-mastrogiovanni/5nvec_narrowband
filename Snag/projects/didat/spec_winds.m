% spec_winds spectral windows 


%% Start

N=16384;

N2=N/2;
N4=N/4;
x=-N2+1:N2;

hann=(cos(x*2*pi/N)+1)/2;
hann_sr=sqrt(hann);

flat=ones(N,1);
flat0=flat;
flat(1:N4)=(cos(x(1:2:N2)*2*pi/N)+1)/2;
flat(N:-1:N2+N4+1)=flat(1:N4);
flat2=flat.^2;

x=hann;
x(N+1:8*N)=0;
sh=abs(fft(x)).^2;
sh=rota(sh,N2);

x=hann_sr;
x(N+1:8*N)=0;
shsr=abs(fft(x)).^2;
shsr=rota(shsr,N2);

x=flat0;
x(N+1:8*N)=0;
sf0=abs(fft(x)).^2;
sf0=rota(sf0,N2);

x=flat;
x(N+1:8*N)=0;
sf=abs(fft(x)).^2;
sf=rota(sf,N2);

x=flat2;
x(N+1:8*N)=0;
sf2=abs(fft(x)).^2;
sf2=rota(sf2,N2);

%% Figure 1
x=(-N2:N2-1)/8;
figure
semilogy(x,sf0(1:N),'k');
hold on, grid on
semilogy(x,sf(1:N),'b');
semilogy(x,sf2(1:N),'g');
semilogy(x,sh(1:N),'r');
semilogy(x,shsr(1:N),'m');

%% Figure 2
dt=0.001;
nu=100;
dnu=1;
t=(0:N-1)*dt;
fi=t+(dnu/nu)*t.^2;
y=sin(fi*2*pi*nu);%size(y),size(flat)

sf=abs(fft(flat'.*y)).^2;
figure,semilogy(sf);
hold on, grid on
sh=abs(fft(hann.*y)).^2;
semilogy(sh,'r');
s=abs(fft(y)).^2;
semilogy(s,'k');

title('Spectrum from varying frequency signal')
xlabel('Hz')