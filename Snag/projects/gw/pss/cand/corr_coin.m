function out=corr_coin(coin,dfr,selind)
% correlation for coincidences
%
%    out=corr_coin(coin,dfr,selind)
% 
%  coin    coincidence structure
%  dfr     frequency step (def 0.1 Hz)
%  selind  selection indices (def all)

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

N=length(coin.indcoin);
if ~exist('selind','var')
    selind=0;
end
if selind == 0
    selind=1:N;
end
if ~exist('dfr','var')
    dfr=0.1;
end

cl1=coin.clust1;
indcoin=coin.indcoin;
cl2=coin.clust2;
cref=coin.cref;
can1=coin.cand1(cref(:,2),:);
can2=coin.cand2(cref(:,3),:);

F1=can1(selind,1);
F2=can2(selind,1);
F=(F1+F2)/2;
minF=min(F);
maxF=max(F);

amp1=cl1(15,selind);
amp2=cl2(15,selind);
amp0=amp1/mean(amp1)+amp2/mean(amp2);
Amp1=can1(selind,5);
Amp2=can2(selind,5);
Amp0=Amp1/mean(Amp1)+Amp2/mean(Amp2);
h1=cl1(19,selind);
h2=cl2(19,selind);
h0=(h1+h2)/2;
H1=can1(selind,9);
H2=can2(selind,9);
H0=(H1+H2)/2;

n=ceil((maxF-minF)/dfr);
ff=minF+(0:n)*dfr;
corrA=zeros(1,n);
corrH=corrA;
corra=corrA;
corrh=corrA;
nn=corrA;
rre=nn;
rrn=nn;
statA1=nn;
statA2=nn;
statH1=nn;
statH2=nn;
stata1=nn;
stata2=nn;
stath1=nn;
stath2=nn;

for i = 1:n
    ii=find(F >= ff(i) & F < ff(i+1));
    ll=length(ii);
    if ll > 1
        nn(i)=ll;
        a=corrcoef(Amp1(ii),Amp2(ii));
        corrA(i)=a(1,2);
        a=corrcoef(H1(ii),H2(ii));
        corrH(i)=a(1,2);
        a=corrcoef(amp1(ii),amp2(ii));
        corra(i)=a(1,2);
        a=corrcoef(h1(ii),h2(ii));
        corrh(i)=a(1,2);
        rande1=randn(1,ll).^2+randn(1,ll).^2;
        rande2=randn(1,ll).^2+randn(1,ll).^2;
        a=corrcoef(rande1,rande2);
        rre(i)=a(1,2);
        a=corrcoef(randn(1,ll),randn(1,ll));
        rrn(i)=a(1,2);
        statA1(i)=mean(Amp1(ii));
        statA2(i)=mean(Amp2(ii));
        statH1(i)=mean(H1(ii));
        statH2(i)=mean(H2(ii));
        stata1(i)=mean(amp1(ii));
        stata2(i)=mean(amp2(ii));
        stath1(i)=mean(h1(ii));
        stath2(i)=mean(h2(ii));
    end
end

out.nn=nn;
out.ff=ff(1:n)+dfr/3;
out.corrA=corrA;
out.corrH=corrH;
out.corra=corra;
out.corrh=corrh;
out.statA1=statA1;
out.statA2=statA2;
out.statH1=statH1;
out.statH2=statH2;
out.stata1=stata1;
out.stata2=stata2;
out.stath1=stath1;
out.stath2=stath2;

figure,plot(out.ff,nn),title('nn'),grid on
figure,plot(out.ff,corrA),title('corrA'),grid on
figure,plot(out.ff,corrH),title('corrH'),grid on
figure,plot(out.ff,corra),title('corra'),grid on
figure,plot(out.ff,corrh),title('corrh'),grid on
figure,plot(out.ff,rre),title('rre'),grid on
figure,plot(out.ff,rrn),title('rrn'),grid on
figure,plot(out.ff,statA1),hold on,plot(out.ff,statA2,'r'),title('A'),grid on
plot(out.ff,stata1,'c'),plot(out.ff,stata2,'m')
figure,plot(out.ff,statH1),hold on,plot(out.ff,statH2,'r'),title('H'),grid on
plot(out.ff,stath1,'c'),plot(out.ff,stath2,'m')

fprintf('nn    : mean,std = %f  %f\n',mean(nn),std(nn));
fprintf('corrA : mean,std = %f  %f\n',mean(corrA),std(corrA));
fprintf('corrH : mean,std = %f  %f\n',mean(corrH),std(corrH));
fprintf('corra : mean,std = %f  %f\n',mean(corra),std(corra));
fprintf('corrh : mean,std = %f  %f\n',mean(corrh),std(corrh));
fprintf('rre  : mean,std = %f  %f\n',mean(rre),std(rre));
fprintf('rrn  : mean,std = %f  %f\n',mean(rrn),std(rrn));