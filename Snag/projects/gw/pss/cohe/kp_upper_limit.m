function [nmf0 nmf45 H1 H2 noise]=kp_upper_limit(X,sour,ant,thr,simcl)
% KP_UPPER_LIMIT  known pulsar upper limits
%
%      ul=kp_upper_limit(X,L0,L45,thr,simcl)
%
%    X         data 5-vect (or external noise X(5,N))
%    sour,ant  source and antenna structures
%    thr       threshold
%    simcl     noise simulation class:
%               0 -> only given X
%               1 -> variation on phases
%               2 -> fixed mod
%               3 -> fixed expected value of mod
%               4 -> external noise

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


if ~exist('simcl','var')
    simcl=1;
end

N=100000;
[L0 L45 CL CR V Hp Hc]=sour_ant_2_5vec(sour,ant);

if length(X) > 5
    simcl=4;
    a0=sqrt(mean(abs(X(:).^2))*5);
else
    a0=norm(X);
end

a1=norm(L0);
a2=norm(L45);
A2_1=a1^2/(a1^2+a2^2);
A2_2=a2^2/(a1^2+a2^2);

noise=zeros(5,N);
nmf0=zeros(1,N);
nmf45=nmf0;

out=rand_point_on_sphere(N);

psi=out(:,1)*pi/720;
eta=sin(out(:,2)*pi/180);

figure,plot(psi*180/pi,eta,'.'),grid on

H1=(cos(2*psi)-1j*eta.*sin(2*psi))./sqrt(1+eta.^2);
H2=(sin(2*psi)+1j*eta.*cos(2*psi))./sqrt(1+eta.^2);

figure,plot(H1,'.'),hold on,grid on,plot(H2,'r.')

figure,plot(abs(H1).^2,abs(H2).^2,'.')

switch simcl
    case 0
        for i = 1:5
            noise(i,1:N)=X(i);
        end
    case 1
        noise=rand(5,N)*2*pi;
        for i = 1:5
            noise(i,:)=X(i)*exp(1j*noise(i,:));
        end
    case 2
        noise=(randn(5,N)+1j*randn(5,N))*a0/sqrt(10);
    case 3
        chiq=sqrt(random('chi2',ones(1,N)*10)/10);
        noise=(randn(5,N)+1j*randn(5,N))*a0/sqrt(10);
        for i = 1:5
            noise(i,:)=noise(i,:).*chiq;
        end
    case 4
        noise=X;
end

nnois=mean(abs(noise(:)).^2)*5;
noise=noise/sqrt(nnois);

for i = 1:N
    nmf0(i)=mf_5vec(noise(:,i).',L0);
    nmf45(i)=mf_5vec(noise(:,i).',L45);
end

filtnois=A2_1.^2*abs(nmf0).^2+A2_2.^2*abs(nmf45).^2;
mdn=mean(filtnois);

nn=1000;
dx=abs(mdn)^2/30;
x=(1:nn)*dx-dx/2;

hdn=hist(filtnois,x)/(N*dx);
fa=cumsum(hdn(nn:-1:1))*dx;
fa=fa(nn:-1:1);

figure,semilogy(x,hdn),grid on

figure,semilogy(x,fa),grid on,title('False Alarm p')

nsig=10;
dsig=0.5;
detp=zeros(nn,nsig);
detd=detp;

fprintf('Mean |nmf0|^2, |nmf45|^2 : %f  %f \n',mean(abs(nmf0).^2),mean(abs(nmf45).^2));
fprintf('Mean |nmf0| , |nmf45|  : %f  %f \n',sqrt(mean(abs(nmf0).^2)),sqrt(mean(abs(nmf45).^2)));

for i = 1:nsig
    amp=sqrt(i*dsig);
    filt=(A2_1.^2)*abs(nmf0.'+H1*amp).^2+(A2_2.^2)*abs(nmf45.'+H2*amp).^2;
%     mean(filt)
    hdf=hist(filt,x)/(N*dx);
    detd(:,i)=hdf;
    de=cumsum(hdf(nn:-1:1))*dx;
    detp(:,i)=de(nn:-1:1);
end

figure,plot(x,detp),grid on,ylim([0 1]),title('Detection p')

figure,plot(fa,detp),grid on
figure,semilogx(fa,detp),grid on

figure,plot(x,hdn,'k'),hold on,plot(x,detd),grid on
figure,semilogy(x,hdn,'k'),hold on,semilogy(x,detd),grid on
