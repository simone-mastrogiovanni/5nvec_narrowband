% test_phase_interp

fr0=100; % in Hz ; notare che qui l'unità di tempo è giorni
dt=0.0001;  % risoluzione temporale in giorni
decifac=103;  % dt*decifac = distanza tra due osservazioni, cioè Tfft/2
distobs=dt*decifac  % giorni
t1=0:dt:365;
n1=length(t1);
fr1=doppler(t1,fr0,0,0,12,42,0); % vero
maxslope=max(diff(fr1))/dt % massima pendenza doppler Hz/giorno
fr2=fr1(1:decifac:n1);
t2=t1(1:decifac:n1);
figure,plot(t1,fr1),hold on,plot(t2,fr2,'rx'),grid on

fri0=interp1(t2,fr2,t1,'nearest'); % no interpolazione
i1=ceil((1+floor(decifac/2):n1+floor(decifac/2))/decifac);
ii=find(i1>length(fr2));i1(ii)=length(fr2);
fri1=fr2(i1); % no interpolazione
fri=interp1(t2,fr2,t1); % interpolazione lineare
errfr=fr1-fri;
figure,plot(t1,errfr),grid on
figure,plot(t1,fr1),hold on,plot(t2,fr2,'rx'),grid on,plot(t1,fri,'g'),plot(t1,fri1,'k')

ph1=cumsum(fr1*86400)*dt*360; % vero
ph2=cumsum(fr2*86400)*dt*decifac*360;
phi=cumsum(fri*86400)*dt*360; % interpolazione lineare
phi0=cumsum(fri0*86400)*dt*360; % no interpolazione
phi1=cumsum(fri1*86400)*dt*360; % no interpolazione
figure,plot(t1,ph1-phi),hold on,plot(t1,ph1-phi1,'r'),grid on

errint=cumsum((fr1-fri)*86400)*dt*360;
errnoint=cumsum((fr1-fri1)*86400)*dt*360;
figure,plot(t1,errnoint,'r'),hold on,plot(t1,errint),grid on