% test_det_4dof

sour=vela;
ant=virgo;
sour.eta=0.3;
sour.psi=30;
% ant.lat=5;
% sour.d=-5;
% sour=pulsar_3
SNR=0.23*(1.25.^[0:30]);
meamp=zeros(1,length(SNR));
stamp=meamp;
meeta=meamp;
steta=meamp;
mepsi=meamp;
stpsi=meamp;
mecoe=meamp;
stcoe=meamp;
mecoe1=meamp;
stcoe1=meamp;
mecoe2=meamp;
stcoe2=meamp;
nn=1000;
eta1=zeros(nn,1);
psi1=eta1;
amp1=eta1;
coe=eta1;
coe1=coe;
coe2=coe;

fprintf('Antenna latitude %f  Source declination,eta,psi %f %f %f \n',ant.lat,sour.d,sour.eta,sour.psi)
[L0 L45 CL CR V Hp Hc]=sour_ant_2_5vec(sour,ant);
Ap2=norm(L0)^2;
Ac2=norm(L45)^2;
fprintf('|A+|^2/|Ax|^2, |V|^2 = %f %f \n',Ap2/Ac2,norm(V)^2)
[eta psi]=ab2etapsi(Hp,Hc);
fprintf('Check source : eta,psi : %f %f \n',eta,psi);
vnorm=norm(V);
vnorm1=norm(L0);
vnorm2=norm(L45);

for j = 1:length(SNR)
    c1=SNR(j);
    c2=1;
    cc=sqrt(c1^2+c2^2);
    c1=c1/cc;
    c2=c2/cc;
    nnorm2=0;
    for i = 1:nn
        N=x_5vec;
        nnorm2=nnorm2+norm(N)^2;
        X=c1*V+c2*N;
        xnorm2=norm(X)^2;

        mf0=mf_5vec(X,L0);
        mf45=mf_5vec(X,L45);
        [eta1(i) psi1(i)]=ab2etapsi(mf0,mf45);
        amp1(i)=sqrt(abs(mf0)^2+abs(mf45)^2);
        coe(i)=norm(mf_5vec(X,V)*V)^2/xnorm2;
        coe1(i)=norm(mf_5vec(X,L0)*L0)^2/xnorm2;
        coe2(i)=norm(mf_5vec(X,L45)*L45)^2/xnorm2;
    end
    nnorm=sqrt(nnorm2/nn);
    snr(j)=c1*vnorm/(c2*nnorm);
    meamp(j)=mean(amp1);
    stamp(j)=std(amp1);
    meeta(j)=mean(eta1);
    steta(j)=std(eta1);
    mepsi(j)=mean(psi1);
    stpsi(j)=std(psi1);
    mecoe(j)=mean(coe);
    stcoe(j)=std(coe);
    mecoe1(j)=mean(coe1);
    stcoe1(j)=std(coe1);
    mecoe2(j)=mean(coe2);
    stcoe2(j)=std(coe2);
end

% figure,loglog(SNR,stamp,'+'),grid on,hold on,loglog(SNR,steta,'r+'),loglog(SNR,stpsi/90,'g+')
% title('St.dev. of the estimation of amplitude,eta and psi (b,c,g)')
% xlabel('SNR')

SNR=snr;

figure,loglog(SNR,stamp),grid on,hold on,loglog(SNR,stamp,'r.'),loglog(SNR,steta,'c'),...
    loglog(SNR,steta,'r.'),loglog(SNR,stpsi/90,'g'),loglog(SNR,stpsi/90,'r.')
title('St.dev. of the estimation of amplitude,eta and psi (b,c,g)')
xlabel('SNR')

figure,semilogx(SNR,meamp),hold on,semilogx(SNR,meamp,'r.'),title('mean(amp)'),xlabel('SNR'),grid on
figure,semilogx(SNR,meeta),hold on,semilogx(SNR,meeta,'r.'),title('mean(eta)'),xlabel('SNR'),grid on
figure,semilogx(SNR,mepsi),hold on,semilogx(SNR,mepsi,'r.'),title('mean(psi)'),xlabel('SNR'),grid on

for i = 1:nn
    N=x_5vec;
    nnorm=norm(N)^2;

    mf0=mf_5vec(N,L0);
    mf45=mf_5vec(N,L45);
    [eta1(i) psi1(i)]=ab2etapsi(mf0,mf45);
    amp1(i)=sqrt(abs(mf0)^2+abs(mf45)^2);
    coe(i)=norm(mf_5vec(N,V)*V)^2/nnorm2;
    coe1(i)=norm(mf_5vec(N,L0)*L0)^2/nnorm2;
    coe2(i)=norm(mf_5vec(N,L45)*L45)^2/nnorm2;
end

fprintf('Only noise: amp,eta,psi: %f±%f  %f±%f  %f±%f  \n',...
    mean(amp1),std(amp1),mean(eta1),std(eta1),mean(psi1),std(psi1))
fprintf('Only noise: coe,coe+,coex: %f±%f  %f±%f  %f±%f  \n',...
    mean(coe),std(coe),mean(coe1),std(coe1),mean(coe2),std(coe2))

figure,loglog(SNR,stcoe),grid on,hold on,loglog(SNR,stcoe,'r.'),loglog(SNR,stcoe1,'c'),...
    loglog(SNR,stcoe1,'r.'),loglog(SNR,stcoe2,'g'),loglog(SNR,stcoe2,'r.')
title('St.dev. of the estimation of coe,coe+,coex (b,c,g)')
xlabel('SNR')

figure,semilogx(SNR,mecoe),grid on,hold on,semilogx(SNR,mecoe,'r.'),semilogx(SNR,mecoe1,'c'),...
    semilogx(SNR,mecoe1,'r.'),semilogx(SNR,mecoe2,'g'),semilogx(SNR,mecoe2,'r.')
title('mean of the estimation of coe,coe+,coex (b,c,g)')
xlabel('SNR')