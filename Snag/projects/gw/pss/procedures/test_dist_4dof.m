% test_dist_4dof

sour=vela;
ant=virgo;
sour.eta=0.3;
sour.psi=30;
ant.lat=5;
sour.d=-5;

fprintf('Antenna latitude %f  Source declination %f  \n',ant.lat,sour.d)
[L0 L45 CL CR V]=sour_ant_2_5vec(sour,ant);
fprintf('|L0|^2, |L45|^2, |L0*L45''|^2 = %f %f %f \n',norm(L0)^2,norm(L45)^2,sum(L0.*conj(L45)))
fprintf('|CL|^2, |CR|^2, |CL*CR''|^2 = %f %f %f \n',norm(CL)^2,norm(CR)^2,sum(CL.*conj(CR)))

L0_2=norm(L0)^2;
L45_2=norm(L45)^2;

N=10000;

X1=(randn(N,5)+1j*randn(N,5))/sqrt(10);
MFL=zeros(N,1);
MFLa=MFL;
MFLb=MFL;
MF=MFL;
CMF=MFL;

for i = 1:N
    X=X1(i,:);
    mf0=mf_5vec(X,L0);
    mf45=mf_5vec(X,L45);
    [a b m2max]=calc_mfmax(L0,L45,mf0,mf45,0);
    MF(i)=m2max;
    MFL(i)=abs(mf0)^2+abs(mf45)^2;
    MFLa(i)=abs(mf0)^2;
    MFLb(i)=abs(mf45)^2;
    CMF(i)=mf0*conj(mf45);
end

mfl=mean(MFL);
mfla=mean(MFLa);
mflb=mean(MFLb);
mf=mean(MF);
cmf=mean(CMF)/sqrt(mfla*mflb)

fprintf('LIN:  mean_+,mean_x,mean sum,mean mf %f %f %f %f \n',mfla,mflb,mfl,mf)

mx=max(max(MFL),max(MF));
nh=100;
dh=mx/nh;
x=(0:dh:mx)+0.5*dh;

hmfl=hist(MFL,x)/(N*dh);
hmf=hist(MF,x)/(N*dh);
hmfla=hist(MFLa,x)/(N*dh);
hmflb=hist(MFLb,x)/(N*dh);

costl=4/mfl;
chil=chi2pdf(x*costl,4)*costl;
costc=4/mf;
chic=chi2pdf(x*costc,4)*costc;

figure,plot(x,hmfl),hold on,plot(x,hmf,'r'),grid on,plot(x,chil,'--'),plot(x,chic,'r--')
figure,semilogy(x,hmfl),hold on,semilogy(x,hmf,'r'),grid on,semilogy(x,chil,'--'),semilogy(x,chic,'r--')