% check_soft_inj_single

% load C:\Users\SergioF\Documents\MATLAB\cand\coin_softinj\simsour_s\SOURCES_Sergio_new
%
%  1   freq
%  2   lambda
%  3   beta
%  4   sd
%  5   h
%  6   SNR
%  7   eta
%  8   psi
%  9   alpha
% 10   delta

% softinj_db_sing
%    source
%  1   freq
%  2   lambda
%  3   beta
%  4   sd
%  5   h
%  6   SNR
%  7   eta
%  8   psi
%  9   alpha
% 10   delta
% 
%    detection
%    first set
% 11   fr
% 12   lam
% 13   bet
% 14   sd
% 15   h
% 16   SNR
% 17   d
% 18   d1
% 19   d2
% 20   d3
% 21   d4
% 22   precision snr
%   second set
% 31   fr
% 32   lam
% 33   bet
% 34   sd
% 35   h
% 36   SNR
% 37   d
% 38   d1
% 39   d2
% 40   d3
% 41   d4
% 42   precision snr

% load C:\Users\SergioF\Documents\MATLAB\cand\coin_softinj\simsour_s\SOURCES_Sergio_new

tic
vt=datevec(now);
% check_typ=2; 'FULL'
% check_typ=1; 'EASYFULL'
dcoin=1.8;
smallSNR=1.5;

ref_dir='C:\Users\SergioF\Documents\MATLAB\SoftInj2015\ref_softinj\';

nsour=500;
% nsour=371 % fino a 100 Hz
nbandmax=11;
% nbandmax=8 % fino a 100 Hz
maxfr=(nbandmax+2)*10;

kbands=1:nbandmax;
% kbands=[11];

% hband=0.01; % max half band

dmax=4;
maxsnr=100;

coin=coin_1_010030_C14_2;
dfr=(coin.info1.run.fr.dnat+coin.info2.run.fr.dnat)/2;
dsd=(coin.info1.run.sd.dnat+coin.info2.run.sd.dnat)/2;
dfr1=coin.info1.run.fr.dnat;
dsd1=coin.info1.run.sd.dnat;
dfr2=coin.info2.run.fr.dnat;
dsd2=coin.info2.run.sd.dnat;
epoch_sour=5.511172409e+04;
epoch_coin=coin.T0;
ncoin=0;
ncointot=0;
noc=0;

fr0=sour(:,1);
sd0=sour(:,4);
sour0=sour;
DFR=sd0*(epoch_coin-epoch_sour)*86400;
fr=fr0+DFR;
sour0(:,1)=fr;

ii=find(sour0(1:nsour,1) <= maxfr);
sour0=sour0(ii,:);
[nsour,dum]=size(sour0);
ii=find(sour0(1:nsour,6) < maxsnr);
sour1=sour0(ii,:);

[nsour1,dum]=size(sour1);
softinj_db_sing=zeros(nsour1,50);
for i = 1:nsour1
    softinj_db_sing(i,1:10)=sour1(i,:);
end
% softinj_db_sing(:,17)=-1;
Scoin={};
ksc=0;

% for i = 1:nbandmax % bands
for i = kbands       % bands
    frin=(i+1)*10;
    frfi=frin+10;
    if i == 1
        frin=10;
    end
    ii=find(sour1(:,1) >= frin & sour1(:,1) <= frfi);
    ss=sour1(ii,:);
    lii=length(ii);
    if lii < 1
        continue
    end
        
    str=sprintf('%03d%03d',frin,frfi);
%     eval(['coin=coin_1_' str '_C14_2;']);
    T1=coin.T1;
    T2=coin.T2;
    Tcoin=coin.T0;
    VR2=['VSR2_1_' str '_ref'];
    VR4=['VSR4_1_' str '_ref'];
    eval(['load ' ref_dir VR2 '.mat'])
    eval(['load ' ref_dir VR4 '.mat'])
    VSR2ref=eval(VR2)
    VSR4ref=eval(VR4)
    disp(['files: ' VR2 ' ' VR4])
    Tcand1=VSR2ref.info.run.epoch;
    cand1=sd_corr_1(VSR2ref.cand,Tcand1,Tcoin);
    Tcand2=VSR4ref.info.run.epoch;
    cand2=sd_corr_1(VSR4ref.cand,Tcand2,Tcoin);
    
    fr=cand1(:,1);
%     i1=1;
%     i2=length(fr);
    
    for j = 1:lii
        iii=find(abs(fr-ss(j,1)) <= dmax*dfr1);
        if length(iii) > 0
            cand11=cand1(iii,:);
            [d,d1,d2,d3,d4]=distance_4_sour(ss(j,:),cand11,dfr,dsd);
            [d0,ii0]=min(d);

            softinj_db_sing(ii(j),11:14)=cand11(ii0,1:4);
            softinj_db_sing(ii(j),15)=cand11(ii0,9);
            softinj_db_sing(ii(j),16)=cand11(ii0,9)*softinj_db_sing(ii(j),6)/softinj_db_sing(ii(j),5);
            softinj_db_sing(ii(j),17)=d(ii0);
            softinj_db_sing(ii(j),18)=d1(ii0);
            softinj_db_sing(ii(j),19)=d2(ii0);
            softinj_db_sing(ii(j),20)=d3(ii0);
            softinj_db_sing(ii(j),21)=d4(ii0);
            softinj_db_sing(ii(j),27)=cand11(ii0,7);
            softinj_db_sing(ii(j),28)=cand11(ii0,8);
        end
    end
   
    fr=cand2(:,1);
%     i1=1;
%     i2=length(fr);
    
    for j = 1:lii
        iii=find(abs(fr-ss(j,1)) <= dmax*dfr1);
        if length(iii) > 0
            cand22=cand2(iii,:);
            [d,d1,d2,d3,d4]=distance_4_sour(ss(j,:),cand22,dfr,dsd);
            [d0,ii0]=min(d);

            softinj_db_sing(ii(j),31:34)=cand22(ii0,1:4);
            softinj_db_sing(ii(j),35)=cand22(ii0,9);
            softinj_db_sing(ii(j),36)=cand22(ii0,9)*softinj_db_sing(ii(j),6)/softinj_db_sing(ii(j),5);
            softinj_db_sing(ii(j),37)=d(ii0);
            softinj_db_sing(ii(j),38)=d1(ii0);
            softinj_db_sing(ii(j),39)=d2(ii0);
            softinj_db_sing(ii(j),40)=d3(ii0);
            softinj_db_sing(ii(j),41)=d4(ii0);
            softinj_db_sing(ii(j),47)=cand22(ii0,7);
            softinj_db_sing(ii(j),48)=cand22(ii0,8);
        end
    end
    clear cand1 cand2
    eval(['clear ' VR2])
    eval(['clear ' VR4])
end

% outs=sim_soft_inj(softinj_db_sing,1);
% softinj_db_sing(:,31)=softinj_db_sing(:,16)./outs.v5nn;
% % si_db(:,31)=si_db(:,16)./outs.vn;
% 
% sky_calib=data_an_pss.sky_calib_virgo;
% xsk=x_gd(sky_calib);
% ysk=y_gd(sky_calib);
% b=abs(softinj_db_sing(:,10));
% b=interp1(xsk,ysk,b);
% softinj_db_sing(:,31)=softinj_db_sing(:,16)./b./outs.v5nn;
% 
% cs=cs(1:ncoin,:);
% nocs=nocs(1:noc,:);
% 
% duration=toc
% savnam=sprintf('check_soft_inj_%04d%02d%02d_%02d%02d',vt(1:5))
% save(savnam,'softinj_db_sing','cs','nocs','Scoin','duration')
% 
% nsour1
% ncoin,ncointot
% 
% snr=cs(:,10);
% [ssnr,isnr]=sort(snr);
% 
% cs=cs(1:ncoin,:);
% nocs=nocs(1:noc,:);
% figure;semilogy(cs(:,4),cs(:,8),'.');
% hold on,grid on,semilogy(cs(:,4),cs(:,9),'r.');title('b coin, r sour'),xlabel('Hz')
% 
% figure;semilogy(cs(:,4),snr,'.');title('coin: SNR vs fr'),grid on,xlabel('Hz')
% 
% gain=cs(:,8)./cs(:,9);
% figure;loglog(snr,gain,'.');title('h_{det} / h_{inj}'),grid on,xlabel('snr')
% xlim([0.3,100])
% 
% out=softinj_recal(cs);
% 
% D1=(sour0(cs(:,1),1)-cs(:,1+3))/dfr;
% D2=(mod(sour0(cs(:,1),2),360)-cs(:,2+3))./cs(:,12);
% D3=(sour0(cs(:,1),3)-cs(:,3+3))./cs(:,13);
% D4=(sour0(cs(:,1),4)-cs(:,4+3))/dsd;
% 
% figure;semilogx(snr,D1,'.');title('d1 of coincidences'),grid on,xlabel('SNR')
% figure;semilogx(snr,D2,'.');title('d2 of coincidences'),grid on,xlabel('SNR')
% figure;semilogx(snr,D3,'.');title('d3 of coincidences'),grid on,xlabel('SNR')
% figure;semilogx(snr,D4,'.');title('d4 of coincidences'),grid on,xlabel('SNR')
% 
% figure,histogram(cs(:,11),40),grid on,title('d1 of coincidences'),xlabel('frequency natural step')
% figure,histogram(cs(:,12),40),grid on,title('d2 of coincidences'),xlabel('lambda natural step')
% figure,histogram(cs(:,13),0:0.1:4),grid on,title('d3 of coincidences'),xlabel('beta natural step')
% figure,histogram(cs(:,14),40),grid on,title('d4 of coincidences'),xlabel('spin-down natural step')
% d0=sqrt(cs(:,11).^2+cs(:,12).^2+cs(:,13).^2+cs(:,14).^2);
% figure,histogram(d0,40),grid on,title('d of coincidences')
% 
% figure;semilogx(snr,cs(:,11),'.');title('d1'),grid on,xlabel('SNR')
% figure;semilogx(snr,cs(:,12),'.');title('d2'),grid on,xlabel('SNR')
% figure;semilogx(snr,cs(:,13),'.');title('d3'),grid on,xlabel('SNR')
% figure;semilogx(snr,cs(:,14),'.');title('d4'),grid on,xlabel('SNR')
% 
% figure;loglog(snr,cs(:,15),'.');title('numerosity'),grid on
% hold on,loglog(snr,cs(:,16),'r.'),xlabel('SNR')
% 
% 
% figure;semilogy(nocs(:,4),nocs(:,8),'.');grid on,title('no-coin'),xlabel('Hz')
% figure;semilogy(nocs(:,4),nocs(:,9),'ko'),xlabel('Hz')
% hold on,semilogy(cs(:,4),snr,'r.');grid on,title('coin (r) and no-coin (k) SNR')
% 
% fprintf(' Big No-Coincidences Table \n\n')
% ii=0;
% for i = 1:noc
%     if nocs(i,9) > 1
%         ii=ii+1;
%         fprintf('%3d  fr = %f  SNR = %f \n',ii,nocs(i,4),nocs(i,9));
%     end
% end
% 
% dxh=0.2;
% xh=-1:dxh:2+dxh/2;
% XH=10.^xh;
% L10htot=log10(sour0(:,6));
% htot=hist(L10htot,xh);
% L10h=log10(cs(:,10));
% h=hist(L10h,xh);
% hno=hist(log10(nocs(:,9)),xh);
% rat=h./(htot+0.01);
% ratno=hno./(htot+0.01);
% figure,stairs(xh,rat);grid on,title('efficiency (red % no coin)'),xlabel('SNR')
% hold on,stairs(xh,ratno,'r');
% 
% nbin=15;
% [hsnrtot,edg]=loghist(sour0(:,6),[0.1,100,nbin],1,2);
% [hsnrcs,edg]=loghist(snr,[0.1,100,nbin],1,2);
% [hsnrnocs,edg]=loghist(nocs(:,9),[0.1,100,nbin],1,2);
% psnrcs=hsnrcs./(hsnrtot+0.01);
% psnrnocs=hsnrnocs./(hsnrtot+0.01);
% figure,stairs(edg,[psnrcs psnrcs(length(psnrcs))]),grid on
% hold on,stairs(edg,[psnrnocs psnrnocs(length(psnrnocs))])
% set(gca, 'XScale', 'log'),title('efficiency (red % no coin)'),xlabel('SNR')
% 
% out=sofinj_efficiency(sour1,cs,nocs);
% 
% md1=zeros(1,nbin);
% md2=md1;
% md3=md1;
% md4=md1;
% md=md1;
% med1=md1;
% med2=md1;
% med3=md1;
% med4=md1;
% med=md1;
% 
% for i = 1:nbin
%     ii=find(snr > edg(i) & snr <= edg(i+1));
%     md1(i)=mean(cs(ii,11));
%     md2(i)=mean(cs(ii,12));
%     md3(i)=mean(cs(ii,13));
%     md4(i)=mean(cs(ii,14));
%     md(i)=mean(sqrt(cs(ii,11).^2+cs(ii,12).^2+cs(ii,13).^2+cs(ii,14).^2));
%     med1(i)=median(cs(ii,11));
%     med2(i)=median(cs(ii,12));
%     med3(i)=median(cs(ii,13));
%     med4(i)=median(cs(ii,14));
%     med(i)=median(sqrt(cs(ii,11).^2+cs(ii,12).^2+cs(ii,13).^2+cs(ii,14).^2));
% end
% 
% figure,stairs(edg,[md1 md1(nbin)]),set(gca, 'XScale', 'log')
% grid on,title('freq uncertainty (red median)'),xlabel('SNR')
% hold on,stairs(edg,[med1 med1(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
% 
% figure,stairs(edg,[md2 md2(nbin)]),set(gca, 'XScale', 'log')
% grid on,title('lambda uncertainty (red median)'),xlabel('SNR')
% hold on,stairs(edg,[med2 med2(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
% 
% figure,stairs(edg,[md3 md3(nbin)]),set(gca, 'XScale', 'log')
% grid on,title('beta uncertainty (red median)'),xlabel('SNR')
% hold on,stairs(edg,[med3 med3(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
% 
% figure,stairs(edg,[md4 md4(nbin)]),set(gca, 'XScale', 'log')
% grid on,title('spin-down uncertainty (red median)'),xlabel('SNR')
% hold on,stairs(edg,[med4 med4(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
% 
% figure,stairs(edg,[md md(nbin)]),set(gca, 'XScale', 'log')
% grid on,title('full uncertainty (red median)'),xlabel('SNR')
% hold on,stairs(edg,[med med(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
