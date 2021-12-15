% base_pss_eval

% carica 'data_an_pss.mat'

N1=sqrt(data_an_pss.VSR2.calib.wsp)*10^-20;
N2=sqrt(data_an_pss.VSR4.calib.wsp)*10^-20;
figure,semilogy(N1,N2);
grid on,title('Wienerized h noise (blue VSR2, red VSR4)')
xlim([20,128])

v2=VSR2;
v4=VSR4;
TO1=(v2.fin-v2.ini)*86400;
TO2=(v4.fin-v4.ini)*86400;
Tcoh=8192;
nO1=TO1/Tcoh;
nO2=TO2/Tcoh;

level=1;
H1=level*N1/sqrt(Tcoh);
H2=level*N2/sqrt(Tcoh);
H0=max(H1,H2);

figure,semilogy(H1,H2);
grid on,title('Detectability at level 2 (blue VSR2, red VSR4)')
xlim([20,128])
figure,semilogy(H0);
grid on,title('Coincidence detectability at level 1')
xlim([20,128])

% PARAMETRI INJECTIONS 

N=500;
% hh=[0.9 90];
hh=[0.4 12];
fr=[20 128 3];
sd=[-1e-10 1.5e-11];

sour=pss_rand_sour(N,hh,fr,sd,H0);

% multisour=zeros(N,4);
% multisour(:,1)=sour(:,9);
% multisour(:,2)=sour(:,10);
% multisour(:,3)=sour(:,7);
% multisour(:,4)=sour(:,8);
% 
% [v,vn]=multisour_ant_2_5vec(virgo,multisour);

out=sim_soft_inj(sour,(nO1+nO2)/2);

figure,plot(out.v5nn,'.'),grid on,title('5-vec norm')
figure,plot(sour(:,10),out.v5nn,'.'),grid on,title('5-vec norm vs declination')
figure,plot(sour(:,7),out.v5nn,'.'),grid on,title('5-vec norm vs eta')

figure,plot(sour(:,1),out.sn,'O'),grid on,hold on
plot(sour(out.det,1),out.sn(out.det),'rO'),title('SNR vs fr')

figure,semilogy(sour(:,1),out.signal,'O'),grid on,hold on
semilogy(sour(out.det,1),out.signal(out.det),'rO'),title('signal vs fr')

figure,loglog(sour(:,6),out.signorm,'O'),grid on,hold on
loglog(sour(out.det,6),out.signorm(out.det),'rO'),title('hnorm\_det vs hnorm\_inj')
loglog(sour(:,6),sour(:,6),'c.')

candh=2.^((1:17)*0.3);
out1=pss_upper_limit(sour(:,6),out.signorm,0.9,candh)

figure,semilogx(candh,out1.ul,'O'),grid on,hold on,plot(candh,candh,'c')
title('upper limit vs big cand')

figure,semilogx(candh,out1.ulrat,'O'),grid on
title('upper limit "gain" vs big cand')

figure,plot(out1.ninj,out1.ninjok,'ro'),grid on,hold on,plot(out1.ninj,out1.ninj,'c')
title('upper limit: inj used vs inj greater than cands')

figure,plot(out1.ninj,'o'),grid on,hold on,plot(out1.ninjok,'ro')
title('upper limit: inj used and inj greater than cands')
