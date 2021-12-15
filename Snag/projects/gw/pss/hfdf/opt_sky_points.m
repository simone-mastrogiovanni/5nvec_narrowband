% opt_sky_points calcolo del massimo su Tobs 

Tobs=0.001; % in frazione di anni

N=1000;
x=(1:N*(1+Tobs)+10)*2*pi/N;

y=sin(x);
y1=(1:N)*0;

for i=1:N
    y1(i)=max(abs(y(i:i+N*Tobs)));
end

figure, plot(y(1:N)),grid on, hold on,plot(y1,'r')

my1=mean(y1);
my1^2