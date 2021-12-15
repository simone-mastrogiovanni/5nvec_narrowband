% test_maxpar_mf_0

sour=vela;
ant=virgo;
sour.eta=0.3;
sour.psi=30;
ant.lat=5;
sour.d=-5;

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

mf0=mf_5vec(X,L0);
mf45=mf_5vec(X,L45);
mfL=mf_5vec(X,CL);
mfR=mf_5vec(X,CR);
% amf0=abs(mf0)
% amf45=abs(mf45)
% amf2=amf0^2+amf45^2

[eta1 psi1]=etapsi_from2comp(mf0,mf45,1,1);
[eta1c psi1c]=etapsi_from2comp(mfL,mfR,2,1);

[M eta psi C histM xhistM]=etapsi_mf(X,L0,L45,neta,npsi,1);
[a b m2max]=calc_mfmax(L0,L45,mf0,mf45,1);
aphi_mf(X,L0,L45,neta,2*npsi);

disp(' ')
disp(' ---> MF on random data (circular polarization base)')
[Mcirc eta psi Ccirc histMc xhistMc]=etapsi_mf(X,CL,CR,neta,npsi,2);

disp(' ')
disp(' ---> MF on signal data')

Vmf0=mf_5vec(V,L0);
Vmf45=mf_5vec(V,L45);
VmfL=mf_5vec(V,CL);
VmfR=mf_5vec(V,CR);
% aVmf0=abs(Vmf0)
% aVmf45=abs(Vmf45)
% Vamf2=abs(Vmf0)^2+abs(Vmf45)^2

[eta2 psi2]=etapsi_from2comp(Vmf0,Vmf45,1,1);
[eta2c psi2c]=etapsi_from2comp(VmfL,VmfR,2,1);
[Mv eta psi Cv histM xhistM]=etapsi_mf(V,L0,L45,neta,npsi,1);
[a b m2max]=calc_mfmax(L0,L45,Vmf0,Vmf45,1);
aphi_mf(V,L0,L45,neta,2*npsi);

snr0=norm(V)/norm(X);
snr=1; % set the snr

disp(' ')
disp(' ---> MF on signal+noise data')
fprintf('   snr0 = %f   snr = %f \n',snr0,snr)

snmf0=mf_5vec(V*snr/snr0+X,L0);
snmf45=mf_5vec(V*snr/snr0+X,L45);

[eta3 psi3]=etapsi_from2comp(snmf0,snmf45,1,1);
[Mvx eta psi Cv histM xhistM]=etapsi_mf(V*snr/snr0+X,L0,L45,neta,npsi,1);

% A1=zeros(length(eta),length(psi));
% % C1=A1;
% % M1=A1;
% % U1=M1;
% 
% for i = 1:neta
%     etai=eta(i);
%     for j = 1:npsi
%         psi2=psi(j)*pi/90;
%         Hp=sqrt(1/(1+etai^2))*(cos(psi2)-1j*etai*sin(psi2));
%         Hc=sqrt(1/(1+etai^2))*(sin(psi2)+1j*etai*cos(psi2));
%         A=Hp.*L0+Hc.*L45;
%         A1(i,j)=norm(A);
% %         C1(i,j)=(norm(mf_5vec(X,A)*A)/norm(X))^2;
% %         M1(i,j)=mf_5vec(X,A);
% %         U1(i,j)=abs(Hp)^2+abs(Hc)^2;
%     end
% end
% 
% % figure,image(psi,eta,C1,'CDataMapping','scaled'),colorbar,title('Coherence')
% figure,image(psi,eta,A1,'CDataMapping','scaled'),colorbar,title('Power')
% % figure,image(psi,eta,abs(M1).^2,'CDataMapping','scaled'),colorbar,title('MF')
% % figure,image(psi,eta,U1,'CDataMapping','scaled'),colorbar,title('Coefficients')

