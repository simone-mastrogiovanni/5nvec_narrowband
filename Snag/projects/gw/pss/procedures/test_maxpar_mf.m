% test_maxpar_mf

sour=vela;
ant=virgo;
sour.eta=0.3;
sour.psi=30;
ant.lat=5;
sour.d=-5;

disp(' ---------------------')
disp(' ')

fprintf('Antenna latitude %f  Source declination,eta,psi %f %f %f \n',ant.lat,sour.d,sour.eta,sour.psi)
[L0 L45 CL CR V Hp Hc]=sour_ant_2_5vec(sour,ant);
Ap2=norm(L0)^2;
Ac2=norm(L45)^2;
fprintf('|A+|^2, |Ax|^2, |V|^2 = %f %f %f \n',Ap2,Ac2,norm(V)^2)
[eta psi]=ab2etapsi(Hp,Hc);
fprintf('Check source : eta,psi : %f %f \n',eta,psi);

X=x_5vec;

neta=101;
npsi=90;

disp(' ')
disp(' ---> MF on random data')

[etan psin amp2n an bn]=par4dof_5meth(X,L0,L45);

disp(' ')
disp(' ---> MF on signal data')

[etas psis amps2s as bs]=par4dof_5meth(V,L0,L45);

disp(' ')
disp(' ---> MF on signal+noise data')

snr0=norm(V)/norm(X);
snr=1; % set the snr
snmf0=mf_5vec(V*snr/snr0+X,L0);
snmf45=mf_5vec(V*snr/snr0+X,L45);

fprintf('   snr0 = %f   snr = %f \n',snr0,snr)

[etasn psins amps2sn asn bsn]=par4dof_5meth(V*snr/snr0+X,L0,L45);