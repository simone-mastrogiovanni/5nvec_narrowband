function discr=LM_gendiscr(discr,ic)
% LM_GENDISCR  base per simulazione distribuzione discreta
%
%   discr=LM_gendiscr(discr,ic) o discr=LM_gendiscr(discr) o discr=LM_gendiscr
%
%   discr        struttura (se non c'è la crea)
%        .f      distribuzione (in input anche non normalizzata)
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
if ~exist('discr','var')
    icdad=0;
else
    icdad=1;
end

if icdad == 0
    nn=max(2,round(rand(1,1)*50));
    discr.f=rand(1,nn);
    discr.h(1:nn)=0;
    discr.ndef=100;
    discr.ntot=0;
end

N=length(discr.f);

if ic == 0
    discr.h(1:N)=0;
    discr.ntot=0;
end

discr.gdl=N-1;

s=sum(discr.f);
discr.f=discr.f/s;
F=cumsum(discr.f);
r=rand(1,discr.ndef);
for i = 1:discr.ndef
    lanci(i)=find(F-r(i)>0,1,'first');
end
h=hist(lanci,1:N);
discr.h=discr.h+h;
discr.ntot=discr.ntot+discr.ndef;
discr.chiq=sum((discr.h-discr.f*discr.ntot).^2./(discr.f.*(1-discr.f)*discr.ntot));
discr.prob=chi2cdf(discr.chiq,discr.gdl);

discr.hfig=figure;hold on
x=[0 1:N N+1];
h=[0 discr.h 0];
f0=[0 discr.f 0];
f=f0*discr.ntot;
sd=sqrt(f0.*(1-f0)*discr.ntot);
[x1 f1]=tostairs(x,f);
[x2 h1]=tostairs(x,h);
[x1 sd]=tostairs(x,sd);
plot(x1,f1,'k--','LineWidth',2)
plot(x1,f1-sd,'g'),plot(x1,f1+sd,'g'),grid on
plot(x2,h1,'r')

[me st sk ku su]=discr_distr(1:N,discr.h/discr.ntot)