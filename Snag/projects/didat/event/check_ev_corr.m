% check_ev_corr  conta eventi in dati correlati

set_random

filtsi=1

n=4;
N=2^21;
Ntot=N*n;

mu=N/20;
sig=N/200;
sfreq=20000;

tau=6  % tau
tau0=floor(tau*sfreq);
nosearch=ceil(2*tau0);
if nosearch > N/2
    disp('tau troppo alto; lo riduco')
    tau0=N/2-4;
end
Ttot=(Ntot-nosearch)/sfreq
deadt=0.5  % tempo morto
deadt0=floor(deadt*sfreq);
thr=3.5 % soglia
evfound=0;

for i = 1:n
    y=randn(1,N);

    if filtsi == 1
        yy=fft(y);

        yy(1:N/2)=yy(1:N/2).*exp(-((1:N/2)-mu).^2/(2*sig^2));
        yy(N/2+1)=0;
        yy(N:-1:N/2+2)=conj(yy(2:N/2));

        y=ifft(yy);
    end

    me=mean(y);
    st=std(y);
    y=(y-me)/st;

    [ind,len,snr,amp,t,tmax,snr1]=gd_findev(y,tau0,deadt0,thr,0);
    [ii,jj]=find(ind>nosearch);

    evfound=length(jj)+evfound;
end

evfound
nev3ore=evfound*3*3600/Ttot
deadt_perc=evfound*deadt/Ttot
