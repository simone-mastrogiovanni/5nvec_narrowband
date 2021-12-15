function out=hough_MC_calib(Nfft,thresh,multisour,ant,maxamp,N,Tfft)
% montecarlo for the hough calibration
%
%     out=hough_MC_calib(Nfft,thresh,maxamp,sour,N)
%
%   Nfft          number of the ffts (3896 for VSR2 and 1978 for VSR4)
%   thresh        threshold(s) on the normalized periodograms
%   multisour     multi-source (variability on declination, eta and psi)
%   maxamp2       max signal amplitude (normalized linear)
%                   if 2 values, [maxamp damp]
%   N             dimension of the montecarlo (divided by 100)
%   Tfft          duration of the ffts (s)

% Version 2.0 - March 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

damp=0.1;

if length(maxamp) == 2
    damp=maxamp(2);
    maxamp=maxamp(1);
end
nthr=length(thresh);

% [sidpat,wsid0,nsid]=multi_pss_sidpat(multisour,ant,Tfft);
% isid=ceil(rand(1,Nfft)*nsid);
% radpat=sidpat(isid);
% wsid=wsid0(isid);
[sidpat,wsid0,ndecl,neta,npsi,nsid]=multi_pss_sidpat(multisour,ant,Tfft);

npol=neta*npsi;
if N > npol*ndecl
    N=npol*ndecl;
    fprintf('N reduced to %d \n',N);
end
kdecl=ceil(rand(1,N)*ndecl);
kpol=ceil(rand(1,N)*npol);

amp=0:damp:maxamp;
amp2=amp.^2;
na=length(amp2);
hough=zeros(nthr,na,N);  % nthr,na,N,size(hough)
whough=hough;
dump1=hough;
kNfft=ceil((1:Nfft)*nsid/Nfft); 

for j = 1:N
    radpat1=squeeze(sidpat(kdecl(j),kpol(j),:));
    radpat=radpat1(kNfft);
    wsid1=wsid0(kdecl(j),:);
    wsid=wsid1(kNfft); % plot(wsid),pause(5),hold on
    r=randn(6,Nfft)*sqrt(0.5);
    a1=r(3,:).^2+r(4,:).^2;
    a2=r(5,:).^2+r(6,:).^2;
    for k = 1:nthr
        for i = 1:na
            a=(sqrt(amp2(i)*radpat')+r(1,:)).^2+r(2,:).^2; % fprintf('%d %f \n',i,mean(a))
            ii=find(a > thresh(k));
            iii=find(a(ii) > a1(ii) & a(ii) > a2(ii));
            hough(k,i,j)=length(iii);
            whough(k,i,j)=sum(wsid(ii(iii)));
            dump1(k,i,j)=mean(a);
        end
    end
end

mea=zeros(na,nthr);
sig=mea;
pval=mea;
np=5;
p=zeros(np+1,nthr);

for k = 1:nthr
    h1=squeeze(hough(k,:,:))';
    mea1=mean(h1);
    mea(:,k)=mea1;
    Dmea(:,k)=mea1-mea1(1);
    sig(:,k)=std(h1);
    xx=Dmea(:,k);  % size(xx),size(amp2),size(hough)
    p(:,k)=polyfit(xx,amp2',np);
    pval(:,k)=polyval(p(:,k),xx);
    
    wh1=squeeze(whough(k,:,:))';
    wmea1=mean(wh1);
    wmea(:,k)=wmea1;
    Dwmea(:,k)=wmea1-wmea1(1);
    wsig(:,k)=std(wh1);
    wxx=Dwmea(:,k);
    wp(:,k)=polyfit(wxx,amp2',np);
    wpval(:,k)=polyval(wp(:,k),wxx);
end

out.npol=ndecl;
out.npol=neta;
out.npol=npsi;
out.amp2=amp2;
out.mean=squeeze(mea);
out.Dmean=squeeze(Dmea);
out.sig=squeeze(sig);
out.hough=squeeze(hough);out.amp2=amp2;
out.wmean=squeeze(wmea);
out.Dwmean=squeeze(Dwmea);
out.wsig=squeeze(wsig);
out.whough=squeeze(whough);
out.np=np;
out.p=p;
out.pval=pval;
out.wp=wp;
out.wpval=wpval;

out.dump1=squeeze(dump1);

figure,plot(amp2,out.mean),grid on,title('Hough peak vs h-amp^2'),xlabel('h-amp^2'),ylabel('Hough peak')
xlim([0 max(amp2)]);hold on,plot(amp2,out.wmean,'r.')
figure,plot(amp(1:na-1),diff(out.mean)./diff(amp2')),grid on,title('Sensitivity: D(Hough peak)/D(h-amp^2) vs h-amp'),xlabel('h-amp'),ylabel('Quadratic gain')
xlim([0 max(amp)]);hold on,plot(amp(1:na-1),diff(out.wmean)./diff(amp2'),'r.')
figure,plot(out.Dmean,amp2),grid on,title('h-amp^2 vs Hough peak enhancement'),ylabel('h-amp^2'),xlabel('Hough peak')
xlim([0 max(out.Dmean(:))]);hold on,plot(out.Dwmean,amp2,'r.')
figure,semilogy(out.Dmean,amp2),grid on,title('h-amp^2 vs Hough peak enhancement'),ylabel('h-amp^2'),xlabel('Hough peak')
xlim([0 max(out.Dmean(:))]);hold on,plot(out.Dwmean,amp2,'r.')
figure,loglog(out.Dmean,amp2),grid on,title('h-amp^2 vs Hough peak enhancement'),ylabel('h-amp^2'),xlabel('Hough peak')
xlim([0 max(out.Dmean(:))]);hold on,plot(out.Dwmean,amp2,'r.')
figure,plot(amp2,out.sig,'.'),grid on,title('Hough peak st.dev. vs h-amp'),xlabel('h-amp'),ylabel('Hough peak st.dev')
hold on,plot(amp2,out.wsig,'r.')