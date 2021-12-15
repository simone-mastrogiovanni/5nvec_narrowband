function dcont=LM_distcont(dcont,ic)
% LM_DISTCONT  base per simulazione distribuzione continua
%
%   dcont=LM_distcont(dcont,ic) o dcont=LM_distcont(dcont) o dcont=LM_distcont
%
%   dcont        struttura (se non c'è la crea)
%        .tipo   tipo ('gaus' 'exp' 'chiq' 'cauchy' 'genpar' 'lapl' 'lognorm' 'ncchiq'
%                      'rayl' 'stud' 'unif'
%        .par    parameters:
%                   gaus       mu,sigma
%                   exp        mu
%                   chiq       gdl
%                   cauchy     mu d
%                   genpar     K sigma theta
%                   lapl       b
%                   lognorm    mu sigma
%                   ncchiq     gdl delta
%                   rayl       B
%                   stud       gdl
%                   unif       A B
%        .f      distribuzione (solo in output)
%        .minx   minimo per l'istogramma
%        .maxx   massimo per l'istogramma
%        .N      numero bin dell'istogramma
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
if ~exist('dcont','var')
    icbin=0;
else
    icbin=1;
end

if icbin == 0
    dcont.tipo='gaus';
    dcont.par=[0 1];
    dcont.minx=-5;
    dcont.maxx=5;
    dcont.N=200;
    dcont.h(1:dcont.N)=0;
    dcont.ndef=100;
    dcont.ntot=0;
end

tipo=dcont.tipo;
par=dcont.par;
N=dcont.N;
dcont.gdl=N-1;
x=dcont.minx+(0:N-1)*(dcont.maxx-dcont.minx)/(N-1);
par=dcont.par;
ndef=dcont.ndef;

if ic == 0
    dcont.h(1:N)=0;
    dcont.ntot=0;
end

switch tipo
    case 'gaus'
        dcont.f=normpdf(x,par(1),par(2));
        lanci=par(1)+par(2)*randn(ndef,1);
    case 'exp'
        dcont.f=exppdf(x,par(1));
        lanci=exprnd(par(1),ndef,1);
    case 'chiq'
        dcont.f=chi2pdf(x,par(1));
        lanci=chi2rnd(par(1),ndef,1);
    case 'cauchy'
        dcont.f=cauchypdf(x,par(1),par(2));
        lanci=cauchyrnd(par(1),par(2),ndef,1);
    case 'genpar'
        dcont.f=gppdf(x,par(1),par(2),par(3));
        lanci=gprnd(par(1),par(2),par(3),ndef,1);
    case 'lapl'
        dcont.f=laplpdf(x,par(1));
        lanci=laplrnd(par(1),ndef,1);
    case 'lognorm'
        dcont.f=lognpdf(x,par(1),par(2));
        lanci=lognrnd(par(1),par(2),ndef,1);
    case 'ncchiq'
        dcont.f=ncx2pdf(x,par(1),par(2));
        lanci=ncx2rnd(par(1),par(2),ndef,1);
    case 'rayl'
        dcont.f=raylpdf(x,par(1));
        lanci=raylrnd(par(1),ndef,1);
    case 'stud'
        dcont.f=tpdf(x,par(1));
        lanci=raylrnd(par(1),ndef,1);
    case 'unif'
        dcont.f=unifpdf(x,par(1),par(2));
        lanci=unifrnd(par(1),par(2),ndef,1);
end

dcont.f=dcont.f*(dcont.maxx-dcont.minx)/(N-1);
h=hist(lanci,x);
dcont.h=dcont.h+h;
dcont.ntot=dcont.ntot+dcont.ndef;
dcont.chiq=sum((dcont.h-dcont.f*dcont.ntot).^2./(dcont.f.*(1-dcont.f)*dcont.ntot));
dcont.prob=chi2cdf(dcont.chiq,dcont.gdl);

dcont.hfig=figure;hold on
h=dcont.h;
f0=dcont.f;
f=f0*dcont.ntot;
sd=sqrt(f0.*(1-f0)*dcont.ntot);
[x1 f1]=tostairs(x,f);
[x2 h1]=tostairs(x,h);
[x1 sd]=tostairs(x,sd);
plot(x1,f1,'k--','LineWidth',2)
plot(x1,f1-sd,'g'),plot(x1,f1+sd,'g'),grid on
plot(x2,h1,'r')

% [me st sk ku su]=discr_distr(0:N,dcont.h/dcont.ntot)
