function dadi=LM_dadi(dadi,ic)
% LM_DADI  base per simulazione dadi
%
%   dadi=LM_dadi(dadi,ic) o dadi=LM_dadi(dadi) o dadi=LM_dadi
%
%   dadi        struttura (se non c'è la crea)
%       .f      distribuzione (in input anche non normalizzata)
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
if ~exist('dadi','var')
    icdad=0;
else
    icdad=1;
end

if icdad == 0
    dadi.f(1:6)=1/6;
    dadi.h(1:6)=0;
    dadi.ndef=100;
    dadi.ntot=0;
end

if ic == 0
    dadi.h(1:6)=0;
    dadi.ntot=0;
end

dadi.gdl=5;

s=sum(dadi.f);
dadi.f=dadi.f/s;
F=cumsum(dadi.f);
% lanci=floor(rand(1,dadi.ndef)*6+1);
lanci(1:dadi.ndef)=0;
r=rand(1,dadi.ndef);
for i = 1:dadi.ndef
    lanci(i)=find(F-r(i)>0,1,'first');
end
h=hist(lanci,[1 2 3 4 5 6]);
dadi.h=dadi.h+h;
dadi.ntot=dadi.ntot+dadi.ndef;
dadi.chiq=sum((dadi.h-dadi.f*dadi.ntot).^2./(dadi.f.*(1-dadi.f)*dadi.ntot));
dadi.prob=chi2cdf(dadi.chiq,dadi.gdl);

dadi.hfig=figure;hold on
x=[0 1 2 3 4 5 6 7];
h=[0 dadi.h 0];
% f0=[0 dadi.f(1) dadi.f dadi.f(6) 0];
f0=[0 dadi.f 0];
f=f0*dadi.ntot;
sd=sqrt(f0.*(1-f0)*dadi.ntot);
[x1 f1]=tostairs(x,f);
[x2 h1]=tostairs(x,h);
[x1 sd]=tostairs(x,sd);
plot(x1,f1,'k--','LineWidth',2)
plot(x1,f1-sd,'g'),plot(x1,f1+sd,'g'),grid on
plot(x2,h1,'r')

[me st sk ku su]=discr_distr(1:6,dadi.h/dadi.ntot)