function pois=LM_poisson(pois,ic)
% LM_POISSON  base per simulazione poissoniana
%
%   pois=LM_poisson(pois,ic) o pois=LM_poisson(pois) o pois=LM_poisson
%
%   pois        struttura (se non c'è la crea)
%       .mu     valore aspettato
%       .N      valore massimo da considerare
%       .f      distribuzione (solo in output)
%       .h      istogramma
%       .ndef   numero lanci da simulare (in aggiunta)
%       .ntot   numero lanci simulati
%       .hfig   handle alla figura
%       .chiq   chi quadro
%       .gdl    gradi di libertà
%       .prob   probabilità chi quadro
%
%   ic          =0 (default) inizializzazione; =1 update

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('ic','var')
    ic=0;
end
if ~exist('pois','var')
    icbin=0;
else
    icbin=1;
end

if icbin == 0
    pois.mu=6;
    pois.N=20;
    pois.h(1:6)=0;
    pois.ndef=100;
    pois.ntot=0;
end

mu=pois.mu;
N=pois.N;

if ic == 0
    pois.h(1:N+1)=0;
    pois.ntot=0;
end

pois.f=poisspdf(0:N,mu);
pois.gdl=N-1;

lanci=poissrnd(mu,pois.ndef,1);
h=hist(lanci,0:N);
pois.h=pois.h+h;
pois.ntot=pois.ntot+pois.ndef;
pois.chiq=sum((pois.h-pois.f*pois.ntot).^2./(pois.f.*(1-pois.f)*pois.ntot));
pois.prob=chi2cdf(pois.chiq,pois.gdl);

pois.hfig=figure;hold on
x=0:N;
h=pois.h;
f0=pois.f;
f=f0*pois.ntot;
sd=sqrt(f0.*(1-f0)*pois.ntot);
[x1 f1]=tostairs(x,f);
[x2 h1]=tostairs(x,h);
[x1 sd]=tostairs(x,sd);
plot(x1,f1,'k--','LineWidth',2)
plot(x1,f1-sd,'g'),plot(x1,f1+sd,'g'),grid on
plot(x2,h1,'r')

[me st sk ku su]=discr_distr(0:N,pois.h/pois.ntot)