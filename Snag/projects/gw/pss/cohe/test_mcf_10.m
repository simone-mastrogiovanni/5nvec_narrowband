% test_mcf_10
%
% spectral filter and mc filter
% testing also flat filter and max filter

% sf September 2016

N=10000;  % mc points in the 5-vec space
n=2000;   % number of test signals

sour=pulsar_5;
fixed=[sour.a,sour.d];
ant=virgo;

spfilt=crea_spec_filter(sour,ant);
spfilt1=spfilt*5/sum(spfilt);
[aa,ii]=max(spfilt1);
spfilt2=[0 0 0 0 0];
spfilt2(ii)=5;

snr=[0 0.333 0.666 1 1.5 2 3 5]; % the first should be 0
nsnr=length(snr);

mldist=zeros(1,nsnr);
sldist=zeros(1,nsnr);
sdist=zeros(1,nsnr);
meta=zeros(1,nsnr);
mpsi=zeros(1,nsnr);
seta=zeros(1,nsnr);
spsi=zeros(1,nsnr);

NH=300;
minX=0.001;
abase=(1/minX)^(1/NH);
X=minX*abase.^(1:NH);
H=zeros(nsnr,NH);
asig1=zeros(nsnr,n);
psig2=zeros(5,n);
psig3=psig2;
wsig1=asig1;
csig1=asig1;
aH=H;
wH=H;
cH=H;
H1=H;
aX=((1:NH)/NH)*(max(snr)+1).^2;

MCF=crea_mc_filter(ant,fixed,N,0);
[sig,nois,sigeta,sigpsi]=mc_sn_5vec(ant,fixed,n,0);
minx=2;
maxx=0; % spfilt1=[0 0 5 0 0]

for i = 1:length(snr)
    sig1=snr(i)*sig+nois;
    asig1(i,:)=dot(sig1,sig1);
    aH(i,:)=hist(asig1(i,:),aX);
    
    psig1=sig1.*conj(sig1);
    for j = 1:n
        psig2(:,j)=psig1(:,j).*spfilt1';
        psig3(:,j)=psig1(:,j).*spfilt2';
    end
    wsig1(i,:)=sum(psig2);
    wH(i,:)=hist(wsig1(i,:),aX);
    csig1(i,:)=sum(psig3);
    cH(i,:)=hist(csig1(i,:),aX);
    
    out=mc_filter(MCF,sig1,0);
    H(i,:)=hist(out.dist,X);
    ldist=log10(out.dist);
    mldist(i)=10^mean(ldist);
    sldist(i)=10^std(ldist);
    sdist(i)=std(out.dist);
    mdist(i)=mean(out.dist);
    p1dist(i)=prctile(out.dist,10);
    p2dist(i)=prctile(out.dist,90);
    fprintf('snr = %f  mean log distance = %f  std = %f \n',snr(i),mldist(i),sdist(i))
    erreta=out.eta-sigeta;
    errpsi=out.psi-sigpsi;
    ii=find(errpsi>45);
    errpsi(ii)=errpsi(ii)-90;
    ii=find(errpsi<-45);
    errpsi(ii)=errpsi(ii)+90;
    robst=robstat(errpsi,0.1);
    meta(i)=mean(erreta);
    seta(i)=std(erreta);
    mpsi(i)=mean(errpsi);
    spsi(i)=robst(2);
    fprintf('    error on eta %f  %f   error on psi %f  %f \n',meta(i),seta(i),mpsi(i),spsi(i))
    H1(i,:)=hist(out.loss,X);
    lloss=log10(out.loss);
    mlloss(i)=10^mean(lloss);
    slloss(i)=10^std(lloss);
    sloss(i)=std(out.loss);
    mloss(i)=mean(out.loss);
    p1loss(i)=prctile(out.loss,10);
    p2loss(i)=prctile(out.loss,90);
    fprintf('snr = %f  mean log loss = %f  std = %f \n',snr(i),mlloss(i),sloss(i))
end

ii=find(snr~=0);
figure,loglog(snr(ii),mldist(ii),'o'),xlabel('snr'),ylabel('mean log distance'),grid on
figure,loglog(snr(ii),sldist(ii),'o'),xlabel('snr'),ylabel('std log distance'),grid on
figure,loglog(snr(ii),sdist(ii),'o'),xlabel('snr'),ylabel('std distance'),grid on

figure,loglog(snr(ii),mlloss(ii),'o'),xlabel('snr'),ylabel('mean log loss'),grid on
figure,loglog(snr(ii),slloss(ii),'o'),xlabel('snr'),ylabel('std log loss'),grid on
figure,loglog(snr(ii),sloss(ii),'o'),xlabel('snr'),ylabel('std loss'),grid on

figure,loglog(snr(ii),abs(meta(ii)),'o'),xlabel('snr'),ylabel('mean eta error'),grid on
figure,loglog(snr(ii),seta(ii),'ro'),xlabel('snr'),ylabel('std eta error'),grid on
figure,semilogx(snr(ii),mpsi(ii),'o'),xlabel('snr'),ylabel('mean psi error'),grid on
figure,loglog(snr(ii),spsi(ii),'ro'),xlabel('snr'),ylabel('std psi error'),grid on

roc=cumsum(H,2)/n;

figure,hold on,grid on
for i = 2:nsnr
    loglog(roc(1,:),roc(i,:))
end
title('ROC'),xlabel('false alarm prob'),ylabel('detection prob')

aroc=cumsum(aH(:,NH:-1:1),2)/n;

figure,hold on,grid on
for i = 2:nsnr
    loglog(aroc(1,:),aroc(i,:))
end
title('aROC, wROC and cROC'),xlabel('false alarm prob'),ylabel('detection prob')

wroc=cumsum(wH(:,NH:-1:1),2)/n;

% figure,hold on,grid on
for i = 2:nsnr
    loglog(wroc(1,:),wroc(i,:),'--')
end

croc=cumsum(cH(:,NH:-1:1),2)/n;

for i = 2:nsnr
    loglog(croc(1,:),croc(i,:),':')
end

figure
loglog(aX,aroc(1,NH:-1:1)),hold on,grid on
loglog(aX,wroc(1,NH:-1:1),'--'),loglog(aX,croc(1,NH:-1:1),':')
title('False alarm probability for a, w, c spectral filters')
xlabel('Amplitude')

figure,loglog(X,roc(1,:),'.-'),grid on
% figure,loglog(X,roc(1,NH:-1:1),'LineWidth',2),grid on
title('False alarm probability for the mc spectral filter')
xlabel('minimum distance')

figure,plot(snr,mldist,'.-'),grid on,hold on
plot(snr,mdist,'r.-'),plot(snr,p1dist,'r:'),plot(snr,p2dist,'r:'),
xlabel('snr'),title('median and mean distance (with 10, 90 prct)')