% test_check_gauss_ns1
% non-stationary case

N=100000;
dt=1;
clear('gaus')
gaus.amp=1;
gaus.nstau=40000;
puls.lambda=0.001;
puls.taulam=40000;
puls.amp=200;
puls.tauamp=40000;

[g signs lamns pulamp]=gd_nonstat(N,dt,gaus,puls);

den=10;
lenmin=1000;
% taus=[0.5 1 2 4];
taus=[1 2 4];
[sig,sigmf,mf,sig0,sig0ar,pdist,pzero,h,xh]=check_gauss_ns(g,den,lenmin,taus);

xs=(0:N-1)*dt;
[L i2]=size(sig);
xl=(0:L-1)*dt*lenmin+dt*lenmin/2;
figure,plot(xl,sig),grid on
figure,plot(signs,'r'),grid on

figure,plot(xl,sig),grid on,hold on,plot(xl,sigmf)
figure,semilogy(xl,sig0),grid on,hold on,semilogy(xl,sigmf)

figure,plot(g,'c'),hold on,plot(xl,sigmf*2.5),grid on