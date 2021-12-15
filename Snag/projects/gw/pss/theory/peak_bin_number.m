% Spectral peak and bin number

dx=0.01;
xmax=30;
nth=floor(xmax/(dx*10))

nsig=6;
dsig=0.05;

ps=zeros(nsig,nth);

for i = 1:nsig
    y=peak_pot(i*dsig,xmax,dx);
    ps(i,:)=y(10:10:length(y));
end

x=(10:10:length(y))*dx;

figure
plot(x,ps')
grid on

y=spec_rcdf(0,xmax,dx); % no signal

ss=zeros(nsig,nth);

for i = 1:nsig
    y=spec_rcdf(i*dsig,xmax,dx);
    ss(i,:)=y(10:10:length(y));
end

% figure
hold on
plot(x,ss','--')
grid on
