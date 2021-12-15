% test_dist_4dof_1

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

N=100000;

X1=(randn(N,5)+1j*randn(N,5))/sqrt(10);
MFL=zeros(N,1);
MFLa=MFL;
MFLb=MFL;
MFC=MFL;
MFCa=MFL;
MFCb=MFL;

for i = 1:N
    X=X1(i,:);
    mf0=mf_5vec(X,L0);
    mf45=mf_5vec(X,L45);
    mfL=mf_5vec(X,CL);
    mfR=mf_5vec(X,CR);
    MFL(i)=abs(mf0)^2+abs(mf45)^2;
    MFC(i)=abs(mfL)^2+abs(mfR)^2;
    MFLa(i)=abs(mf0)^2;
    MFCa(i)=abs(mfL)^2;
    MFLb(i)=abs(mf45)^2;
    MFCb(i)=abs(mfR)^2;
end

mfl=mean(MFL);
mfc=mean(MFC);
mfla=mean(MFLa);
mfca=mean(MFCa);
mflb=mean(MFLb);
mfcb=mean(MFCb);
err=mean(MFL-MFC)/mfl;
errabs=mean(abs(MFL-MFC))/mfl;

fprintf('LIN:  meana,meanb,mean %f %f %f \n',mfla,mflb,mfl)
fprintf('CIRC: meana,meanb,mean %f %f %f \n',mfca,mfcb,mfc)
fprintf('Err, ErrAbs : %f  %f \n',err,errabs)

mx=max(max(MFL),max(MFC));
nh=100;
dh=mx/nh;
x=(0:dh:mx)+0.5*dh;

hmfl=hist(MFL,x)/(N*dh);
hmfc=hist(MFC,x)/(N*dh);
hmfla=hist(MFLa,x)/(N*dh);
hmfca=hist(MFCa,x)/(N*dh);
hmflb=hist(MFLb,x)/(N*dh);
hmfcb=hist(MFCb,x)/(N*dh);

costl=4/mfl;
chil=chi2pdf(x*costl,4)*costl;
costc=4/mfc;
chic=chi2pdf(x*costc,4)*costc;

figure,plot(x,hmfl),hold on,plot(x,hmfc,'r'),grid on,plot(x,chil,'--'),plot(x,chic,'r--')
figure,semilogy(x,hmfl),hold on,semilogy(x,hmfc,'r'),grid on,semilogy(x,chil,'--'),semilogy(x,chic,'r--')
figure,semilogy(x,hmfla),hold on,semilogy(x,hmflb,'k'),semilogy(x,hmfca,'r'),semilogy(x,hmfcb,'g'),grid on