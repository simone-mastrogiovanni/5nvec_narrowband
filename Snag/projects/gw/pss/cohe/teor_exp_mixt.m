function [detI faI snr roc]=teor_exp_mixt(arat,h0,verb)
% MC_EXP_MIXT  montecarlo for exponential mixtures
%              produces histograms, ROCs and quadratic SNRs
%
%        snr=mc_exp_mixt(arat,h0,verb)
%
%     arat    A ratio (between the lin gain of the 2 modes)
%     h0      amplitude of the signal
%     verb    verbosity (0,1,2)
%
%     snr     1  simple sum
%             2  equi-noise (F statistics)
%             3  wiener
%             4  max mode
%             5  ("0") natural
%             6  +
%             7  x
%     roc     ROC figures

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N0=100;
snr=0;roc=0;

A1=arat;
A2=1;
if A1 < A2
    aa=A1;
    A1=A2;
    A2=aa;
end

c01=A1/sqrt(A1^2+A2^2);
c02=A2/sqrt(A1^2+A2^2);
A1=c01;
A2=c02;

dx=1/N0;
xmax=100;
x0=0:dx:xmax;
N=length(x0);

k1=2*A1^2;
k2=2*A2^2;
lam=h0^2;

%---------- A ----------------

c1=1/2;
c2=1/2;
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=conv(fn1,fn2)*dx;
fsn12=conv(fsn1,fsn2)*dx;
faA=faal(fn12,dx);
detA=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su1]=cont_distr(x,fsn1);
[me2s st sk ku su2]=cont_distr(x,fsn2);
[men st sk ku su3]=cont_distr(x,fn12);
[mes st sk ku su4]=cont_distr(x,fsn12);
sroc=introc(faA,detA);
fprintf(' A: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,sroc,me1,me2,me1s,me2s,men,mes)

%---------- B ----------------

c1=1/c01^2;
c2=1/c02^2;
c1suc2B=c1/c2
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=conv(fn1,fn2)*dx;
fsn12=conv(fsn1,fsn2)*dx;
faB=faal(fn12,dx);
detB=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su1]=cont_distr(x,fsn1);
[me2s st sk ku su2]=cont_distr(x,fsn2);
[men st sk ku su3]=cont_distr(x,fn12);
[mes st sk ku su4]=cont_distr(x,fsn12);
sroc=introc(faB,detB);
fprintf(' B: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,sroc,me1,me2,me1s,me2s,men,mes)

%---------- C ----------------

c1=1/c01^4;
c2=1/c02^4;
c1suc2C=c1/c2
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=conv(fn1,fn2)*dx;
fsn12=conv(fsn1,fsn2)*dx;
faC=faal(fn12,dx);
detC=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su3]=cont_distr(x,fsn1);
[me2s st sk ku su4]=cont_distr(x,fsn2);
[men st sk ku su5]=cont_distr(x,fn12);
[mes st sk ku su6]=cont_distr(x,fsn12);%su1*su2*su3*su4*su5*su6
srocC=introc(faC,detC);
fprintf(' C: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,srocC,me1,me2,me1s,me2s,men,mes)

%---------- D ----------------

c1=0.5;
c2=0.5;
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=fn1;
fsn12=fsn1;
faD=faal(fn12,dx);
detD=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su1]=cont_distr(x,fsn1);
[me2s st sk ku su2]=cont_distr(x,fsn2);
[men st sk ku su3]=cont_distr(x,fn12);
[mes st sk ku su4]=cont_distr(x,fsn12);
sroc=introc(faD,detD);
fprintf(' D: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,sroc,me1,me2,me1s,me2s,men,mes)
% figure,plot(faA,faA,'m--'),grid,hold on,plot(faA,detA),title('ROC curves')
% xlabel('false alarm probability'),ylabel('detection probability')
% plot(faB,detB,'r'),plot(faC,detC,'g'),plot(faD,detD,'k')
% xlim([0 1]),ylim([0 1])

%---------- E ----------------

c1=0:0.002:1;
c2=sqrt(1-c1.^2);
% c2=(1-c1);
n=length(c1);

for i = 1:n
    x=x0/c1(i);
    fn1=fsn(x,k1,0,c1(i));
    fn2=fsn(x,k2,0,c2(i));
    fsn1=fsn(x,k1,lam,c1(i));
    fsn2=fsn(x,k2,lam,c2(i));

    fn12=conv(fn1,fn2)*dx;
    fsn12=conv(fsn1,fsn2)*dx;
    faE0=faal(fn12,dx);
    detE0=faal(fsn12,dx);
    faI(i)=sum(faE0);
    detI(i)=sum(detE0);
    det(i)=introc(faE0,detE0);
end

figure,plot(c1,detI),grid on,hold on,plot(c1,faI,'r')
figure,plot(c1,det),grid on,hold on,plot(c1,det,'r.')
[C I]=max(det); maxdet=C

c1=c1(I);
c2=c2(I);
c1suc2E=c1/c2
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=conv(fn1,fn2)*dx;
fsn12=conv(fsn1,fsn2)*dx;
faE=faal(fn12,dx); % figure,plot(faE)
detE=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su3]=cont_distr(x,fsn1);
[me2s st sk ku su4]=cont_distr(x,fsn2);
[men st sk ku su5]=cont_distr(x,fn12);
[mes st sk ku su6]=cont_distr(x,fsn12);%su1*su2*su3*su4*su5*su6
srocE=introc(faE,detE);
fprintf(' E 1: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,srocE,me1,me2,me1s,me2s,men,mes)

figure,plot(faA,faA,'m--'),grid,hold on,plot(faA,detA),title('ROC curves')
xlabel('false alarm probability'),ylabel('detection probability')
plot(faB,detB,'r'),plot(faC,detC,'g'),plot(faD,detD,'k'),plot(faE,detE,'c')
xlim([0 1]),ylim([0 1])


c1=50*c1;
c2=50*c2;
x=x0/c1;

fn1=fsn(x,k1,0,c1);
fn2=fsn(x,k2,0,c2);
fsn1=fsn(x,k1,lam,c1);
fsn2=fsn(x,k2,lam,c2);

fn12=conv(fn1,fn2)*dx;
fsn12=conv(fsn1,fsn2)*dx;
faE=faal(fn12,dx); % figure,plot(faE)
detE=faal(fsn12,dx);
[me1 st sk ku su1]=cont_distr(x,fn1);
[me2 st sk ku su2]=cont_distr(x,fn2);
[me1s st sk ku su3]=cont_distr(x,fsn1);
[me2s st sk ku su4]=cont_distr(x,fsn2);
[men st sk ku su5]=cont_distr(x,fn12);
[mes st sk ku su6]=cont_distr(x,fsn12);%su1*su2*su3*su4*su5*su6
sroc=introc(faE,detE);
fprintf(' E50: SNR = %f  roc = %f  mu1,2,1s,2s,n,s = %f %f %f, %f %f, %f  \n',...
    (mes-men)/men,sroc,me1,me2,me1s,me2s,men,mes)
fprintf('(ROC_E-ROC_C)/ROC_E = %f \n',(srocE-srocC)/srocE)


function f=fsn(x,k,lam,c)

f=(k/2)*exp(-k*(c*x+lam)/2).*besseli(0,sqrt(k^2*lam*c*x));


function fa=faal(pdf,dx)

N=length(pdf);
fa=cumsum(pdf(N:-1:1))*dx;
fa=fa(N:-1:1);
fa=fa/max(fa);


function sroc=introc(fa,det)

N=length(fa);
sroc=sum(det(1:N-1).*(fa(1:N-1)-fa(2:N)))-0.5;

