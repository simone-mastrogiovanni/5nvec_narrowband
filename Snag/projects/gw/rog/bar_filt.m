function [risp,filt]=bar_filt(n,FB,mod1,mod2,el)
%BAR_FILT  calcola la risposta alla delta e il filtro per una sbarra
%
%   n           numero bin
%   FB          [frmin,frmax] banda di frequenze
%   mod1,mod2   parametri modi [freq,tau,gain,sigmanoise]
%   el          sigma electronic noise

BW=(FB(2)-FB(1));
df=BW/n;

fr=FB(1)+df*(0:n-1);

m1=(fr-mod1(1)).^2+4/(2*pi*mod1(2)).^2;
m1=1./m1;
sm1=sum(m1)*df;
m1=m1/sm1;
figure,plot(fr,m1),grid on,zoom on,hold on;

m2=(fr-mod2(1)).^2+4/(2*pi*mod2(2)).^2;
m2=1./m2;
sm2=sum(m2)*df;
m2=m2/sm2;
plot(fr,m2,'r'),grid on,zoom on,title('Modes');

nois=m1*mod1(4).^2+m2*mod2(4).^2+el.^2/BW;
figure,semilogy(fr,nois),grid on,zoom on,title('Spettro del rumore')

f2=m1*mod1(3).^2+m2*mod2(3).^2;

risp=f2./nois;
figure,semilogy(fr,risp),grid on,zoom on,title('Risposta alla Delta (in freq)')
trisp=real(ifft(half2fullspec(risp)));
dt=1/(2*BW);
figure,plot(((0:length(trisp)-1)-n)*dt,rota(trisp,n));grid on, zoom on, title('Risposta alla Delta (in t)')
hold on,plot(((0:length(trisp)-1)-n)*dt,rota(abs(trisp),n),'g');

risp(n+1:length(trisp))=0;
risp(n-20:n)=risp(n-20:n).*(1-(0:20)/20);
crisp=ifft(risp);
hold on,plot(((0:length(trisp)-1)-n)*dt,2*abs(rota(crisp,n)),'r'),zoom on;

figure,semilogy(((0:length(trisp)-1)-n)*dt,rota(abs(trisp),n));
hold on,semilogy(((0:length(trisp)-1)-n)*dt,2*abs(rota(crisp,n)),'r'),grid on,zoom on
title('Risposta alla Delta (in t)')

filt=sqrt(f2)./nois;
figure,semilogy(fr,filt),grid on,zoom on,title('Filtro (in freq)')
