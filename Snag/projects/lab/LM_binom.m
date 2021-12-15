function binom=LM_binom(binom,ic)
% LM_BINOM  base per simulazione binomiale o altra
%
%   binom=LM_binom(binom,ic) o binom=LM_binom(binom) o binom=LM_binom
%
%   binom        struttura (se non c'è la crea)
%        .p      probabilità di successo
%        .N      numero prove ripetute
%        .f      distribuzione (solo in output)
%        .h      istogramma
%        .ndef   numero lanci da simulare (in aggiunta)
%        .ntot   numero lanci simulati
%        .hfig   handle alla figura
%        .chiq   chi quadro
%        .gdl    gradi di libertà
%        .prob   probabilità chi quadro
%
%   ic           =0 (default) inizializzazione; =1 update

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('ic','var')
    ic=0;
end
if ~exist('binom','var')
    icbin=0;
else
    icbin=1;
end

if icbin == 0
    binom.p=0.5;
    binom.N=20;
    binom.h(1:6)=0;
    binom.ndef=100;
    binom.ntot=0;
end

p=binom.p;
N=binom.N;

if ic == 0
    binom.h(1:N+1)=0;
    binom.ntot=0;
end

binom.f=binopdf(0:N,N,p);
binom.gdl=N-1;

lanci=binornd(N,p,binom.ndef,1);
h=hist(lanci,0:N);
binom.h=binom.h+h;
binom.ntot=binom.ntot+binom.ndef;
binom.chiq=sum((binom.h-binom.f*binom.ntot).^2./(binom.f.*(1-binom.f)*binom.ntot));
binom.prob=chi2cdf(binom.chiq,binom.gdl);

binom.hfig=figure;hold on
x=0:N;
h=binom.h;
% f0=[0 binom.f(1) binom.f binom.f(6) 0];
f0=binom.f;
f=f0*binom.ntot;
sd=sqrt(f0.*(1-f0)*binom.ntot);
[x1 f1]=tostairs(x,f);
[x2 h1]=tostairs(x,h);
[x1 sd]=tostairs(x,sd);
plot(x1,f1,'k--','LineWidth',2)
plot(x1,f1-sd,'g'),plot(x1,f1+sd,'g'),grid on
plot(x2,h1,'r')

[me st sk ku su]=discr_distr(0:N,binom.h/binom.ntot)