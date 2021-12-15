% test_upper_limit
%
% Osservato x, quale è l'upper limit ?

N=10000;
level=0.95;
nois=(randn(1,N)+1j*randn(1,N))/sqrt(2);
ds=0.1;
smax=10;
ns=round(smax/ds)+1;
nthr=20;
dthr=0.2;
det=zeros(ns,nthr);
s=(0:ns-1)*ds;
thr=(1:nthr)*dthr;

for i = 1:ns
    nois1=abs(nois+s(i));
    for j = 1:nthr;
        jj=find(nois1>=thr(j));
        det(i,j)=length(jj)/N;
    end
end

figure,plot(s,det),grid on,xlabel('segnale')
figure,semilogy(s,det),grid on,xlabel('segnale')

figure,plot(thr,det'),grid on,xlabel('soglia')
figure,semilogy(thr,det'),grid on,xlabel('soglia')