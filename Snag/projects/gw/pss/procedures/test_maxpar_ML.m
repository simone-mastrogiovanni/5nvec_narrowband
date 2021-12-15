% test_maxpar_ML

sour=vela;
ant=virgo;
sour.eta=0.3;
sour.psi=30;
ant.lat=70;
sour.d=5;

fprintf('Antenna latitude %f  Source declination,eta,psi %f %f %f \n',ant.lat,sour.d,sour.eta,sour.psi)
[L0 L45 CL CR V]=sour_ant_2_5vec(sour,ant);

X=x_5vec;

neta=101;
npsi=90;

disp(' ')
disp(' ---> MF on random data')

mf0=mf_5vec(X,L0);
mf45=mf_5vec(X,L45);
% amf0=abs(mf0)
% amf45=abs(mf45)
% amf2=amf0^2+amf45^2

[eta1 psi1]=etapsi_from2comp(mf0,mf45,1,1);

[M eta psi C histM xhistM]=etapsi_mf(X,L0,L45,neta,npsi,1);
[M eta psi C]=etapsi_ML(X,L0,L45,neta,npsi,1);
[M eta psi C]=etapsi_ML(X,L0,L45,neta,npsi,2);

disp(' ')
disp(' ---> MF on signal data')

Vmf0=mf_5vec(V,L0);
Vmf45=mf_5vec(V,L45);
% aVmf0=abs(Vmf0)
% aVmf45=abs(Vmf45)
% Vamf2=abs(Vmf0)^2+abs(Vmf45)^2

[eta2 psi2]=etapsi_from2comp(Vmf0,Vmf45,1,1);
[Mv eta psi Cv histM xhistM]=etapsi_mf(V,L0,L45,neta,npsi,1);
[M eta psi C]=etapsi_ML(V,L0,L45,neta,npsi,1);
[M eta psi C]=etapsi_ML(V,L0,L45,neta,npsi,2);

snr0=norm(V)/norm(X);
snr=1; % set the snr
