% test_ar_ext_array_1

tau=[25 50 100 200 400 800 1600 3200 6400 12800 25600 51200];
N=500000;
PER=10000;
eps=0.1;

r=randn(1,N);
[m s]=ar_ext_array(r,tau);
ss0=std(s(N/2:N,:));

caso=5;
switch caso
    case 1
        r=randn(1,N).*(1+eps+sin((1:N)*2*pi/PER));
    case 2
        r=randn(1,N).*(1+eps+sawtooth((1:N)*2*pi/PER,0.));
    case 3
        r=randn(1,N).*(1+eps+rectpuls(sin((1:N)*2*pi/PER)));
    case 4
        r=randn(1,N);
    case 5
        tau0=10;
        f0=filter(1,[1 -exp(-1/tau0)],randn(1,2*N));
        f1=filter(1,[1 -exp(-1/tau0)],randn(1,2*N));
        f0=complex(f0(N+1:2*N),f1(N+1:2*N));
        f0=abs(f0);
        f0=f0/mean(f0);
        r=randn(1,N).*f0;
end
r=r/std(r);
[m s]=ar_ext_array(r,tau);
figure,semilogx(tau,mean(s(N/2:N,:))),grid on
hold on,semilogx(tau,mean(s(N/2:N,:)),'r+')
title('mean std')
figure,loglog(tau,std(s(N/2:N,:))),grid on
hold on,loglog(tau,std(s(N/2:N,:)),'r+')
title('std std')
figure,semilogx(tau,mean(m(N/2:N,:))),grid on
hold on,semilogx(tau,mean(m(N/2:N,:)),'r+')
title('mean mean')
figure,loglog(tau,std(m(N/2:N,:))),grid on
hold on,loglog(tau,std(m(N/2:N,:)),'r+')
title('std mean')

figure,loglog(tau,std(s(N/2:N,:))./ss0,'r+'),grid on