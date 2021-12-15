% check_ps_cmod
% checks complex modulation

sour=pulsar_3;% sour.eta=0
ant=virgo;
N=1000;
f0=0.2123;

[cm A]=sim_ps_st(sour,ant,N);

sour1=sour;

sour1.eta=0;
sour1.psi=0;

[l0 A0]=sim_ps_st(sour1,ant,N);
l0=real(l0);

sour1.eta=0;
sour1.psi=45;

[l45 A45]=sim_ps_st(sour1,ant,N);
l45=real(l45);

x=(0:N-1)*24/N;
figure,plot(x,l0),hold on,plot(x,l45,'r'),grid on,plot(x,sqrt(l0.^2+l45.^2),'k')
xlabel('Local sidereal time'),title('+ mode (blue), x mode (red)'),xlim([0 24])
figure,plot(cm,'k'),hold on, grid on
plot(cm(1),'ko'),plot(cm(round(N/24)),'kx')
title('Complex modulation')

t0=v2mjd([2010 1 1 0 0 0]);
sour.f0=f0;
[gdps A]=sim_ps_nodop(sour,ant,t0,1,86400,0,1);