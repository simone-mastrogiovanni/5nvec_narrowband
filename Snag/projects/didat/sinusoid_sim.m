%% SSS - Smart Sinusoid Simulation
%%
% in sinusoid_sim

%% Basic data

N0=2048*4;
a16=16;
N1=N0*a16;
dt=4/N0;
clear j

fr0=N0/16;
fi0=100;  % in degrees
fi0rad=fi0*pi/180;

t=(0:N0-1)*dt;
y0=exp(j*(t*2*pi*fr0+fi0rad));
y0=y0.*pswindow('flatcos',N0);
y1=zeros(1,N1);
y1(1:N0)=y0;
x0=(0:N0-1);
x1=(0:N1-1)/a16;
figure, plot(t,real(y0))

%% Compute

f0=fft(y0);
f1=fft(y1);

figure, semilogy(x1,abs(f1)), hold on
semilogy(x0,abs(f0),'ro'), grid on

figure, semilogy(x1,abs(f1)), hold on
semilogy(x0,abs(f0),'ro'), grid on
xlim([fr0-20 fr0+20])

