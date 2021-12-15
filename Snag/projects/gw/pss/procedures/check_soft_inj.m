% check_soft_inj

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

% softinj_db
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
% 11   fr
% 12   lam
% 13   bet
% 14   sd
% 15   h
% 16   SNR
% 17   type (0 no coin, 1 standard, 2 strange)
% 18   clust 1
% 19   cand 1
% 20   clust 2
% 21   cand 2
% 22   num1
% 23   num2
% 24   d
% 25   d1
% 26   d2
% 27   d3
% 28   d4
% 29   noise anomaly 1
% 30   noise anomaly 2
% 31   precision snr
%         First set
% 41   fr
% 42   lam
% 43   bet
% 44   sd
% 45   h
% 46   SNR
%         Second set
% 51   fr
% 52   lam
% 53   bet
% 54   sd
% 55   h
% 56   SNR
% 

% load C:\Users\SergioF\Documents\MATLAB\cand\coin_softinj\simsour_s\SOURCES_Sergio_new

tic
vt=datevec(now);
check_typ=2; 'FULL'
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
cs=zeros(nsour1,17);
nocs=zeros(nsour1,11);
softinj_db=zeros(nsour1,60);
for i = 1:nsour1
    softinj_db(i,1:10)=sour1(i,:);
end
softinj_db(:,17)=-1;
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
    str=sprintf('%03d%03d',frin,frfi);
    eval(['coin=coin_1_' str '_C14_2;']);
    if check_typ == 2
        VR2=['VSR2_1_' str '_ref'];
        VR4=['VSR4_1_' str '_ref'];
        eval(['load ' ref_dir VR2 '.mat'])
        eval(['load ' ref_dir VR4 '.mat'])
        VSR2ref=eval(VR2)
        VSR4ref=eval(VR4)
        disp(['files: ' VR2 ' ' VR4])
        [cand1,cand2]=softinj_cands(VSR2ref,VSR4ref,coin);
    end
    [fr,lam,bet,sd,A,h,d,num,dlam,dbet,clusts,cands,frmi,frma]=extr_coin_C14(coin);
    fr_1=fr(1,:);
    fr_2=fr(2,:);
    fr=fr(3,:);
    lam_1=lam(1,:);
    lam_2=lam(2,:);
    lam=lam(3,:);
    bet_1=bet(1,:);
    bet_2=bet(2,:);
    bet=bet(3,:);
    sd_1=sd(1,:);
    sd_2=sd(2,:);
    sd=sd(3,:);
    h_1=h(1,:);
    h_2=h(2,:);
    h=h(3,:);
%     DFR=sd*(epoch_coin-epoch_sour)*86400;
%     fr=fr-DFR;
    lam=mod(lam,360);
    dlam=(dlam(1,:)+dlam(2,:))/2;
    dbet=(dbet(1,:)+dbet(2,:))/2;
    nsc=0;
    
    for j = 1:lii   % sources
        kksour=ii(j);
        softinj_db(kksour,17)=0;
        Dbet=min(abs(bet-ss(j,3)),abs(-bet-ss(j,3)));
        lam1=mod(ss(j,2),360);
        Dlam=mod(abs(lam-lam1),360);
%         Dlam=abs(lam-lam1);
        d1=abs(ss(j,1)-fr)/dfr;
        d2=Dlam./dlam;
        d3=Dbet./dbet;
        d4=abs(ss(j,4)-sd)/dsd;
        d=sqrt(d1.^2+d2.^2+d3.^2+d4.^2);
        iii=find(d <= dmax);
        [mind,jj]=min(d);
        liii=length(iii);
        if liii > 0
            softinj_db(kksour,17)=1;
            softinj_db(kksour,11)=fr(jj);
            softinj_db(kksour,12)=lam(jj);
            softinj_db(kksour,13)=bet(jj);
            softinj_db(kksour,14)=sd(jj);
            softinj_db(kksour,15)=h(jj);
            softinj_db(kksour,16)=ss(j,6)*h(jj)/ss(j,5);
            softinj_db(kksour,18)=1;
            softinj_db(kksour,19)=1;
            softinj_db(kksour,20)=1;
            softinj_db(kksour,21)=1;
            softinj_db(kksour,22)=num(1,jj);
            softinj_db(kksour,23)=num(2,jj);
            softinj_db(kksour,24)=d(jj);
            softinj_db(kksour,25)=d1(jj);
            softinj_db(kksour,26)=d2(jj);
            softinj_db(kksour,27)=d3(jj);
            softinj_db(kksour,28)=d4(jj);
            
            softinj_db(kksour,41)=fr_1(jj);
            softinj_db(kksour,42)=lam_1(jj);
            softinj_db(kksour,43)=bet_1(jj);
            softinj_db(kksour,44)=sd_1(jj);
            softinj_db(kksour,45)=h_1(jj);
            softinj_db(kksour,46)=ss(j,6)*h_1(jj)/ss(j,5);
            
            
            softinj_db(kksour,51)=fr_2(jj);
            softinj_db(kksour,52)=lam_2(jj);
            softinj_db(kksour,53)=bet_2(jj);
            softinj_db(kksour,54)=sd_2(jj);
            softinj_db(kksour,55)=h_2(jj);
            softinj_db(kksour,56)=ss(j,6)*h_2(jj)/ss(j,5);
            
            ncoin=ncoin+1;
            cs(ncoin,1)=ii(j);    % sour
            cs(ncoin,2)=i;        % band
            cs(ncoin,3)=jj;       % k in band
            cs(ncoin,4)=fr(jj);
            cs(ncoin,5)=lam(jj);
            cs(ncoin,6)=bet(jj);
            cs(ncoin,7)=sd(jj);
            cs(ncoin,8)=h(jj);
            cs(ncoin,9)=ss(j,5);  % sour h
            cs(ncoin,10)=ss(j,6); % sour SNR
            cs(ncoin,11)=d1(jj);
            cs(ncoin,12)=d2(jj);
            cs(ncoin,13)=d3(jj);
            cs(ncoin,14)=d4(jj);
            cs(ncoin,15)=num(1,jj);
            cs(ncoin,16)=num(2,jj);
            cs(ncoin,17)=1; % coincidence type
        else
            noc=noc+1;
            nocs(noc,1)=ii(j);
            nocs(noc,2)=i;
            nocs(noc,3)=jj;
            nocs(noc,4)=ss(j,1);
            nocs(noc,5)=ss(j,2);
            nocs(noc,6)=ss(j,3);
            nocs(noc,7)=ss(j,4);
            nocs(noc,8)=ss(j,5);
            nocs(noc,9)=ss(j,6);
            
            if check_typ == 2
                ii3=find(frma(3,:) >= ss(j,1) & frmi(3,:) <= ss(j,1)); % interesting coins
                lii3=length(ii3);
                if ss(j,6) > smallSNR
%                     ltot1=0;
%                     ctot1=0;
%                     ltot2=0;
%                     ctot2=0;
%                     mind1=1e6;
%                     mind2=1e6;
                    if lii3 > 0
                        cl1a=[];
                        cl2a=[];
                        nsc=nsc+1;
                        dat=datestr(now);
                        fprintf(' sc %d *** sour %d  fr %f  SNR  %f Ncoin %d   %s\n',nsc,ii(j),ss(j,1),ss(j,6),lii3,dat)
                        
                        kkcoin=ii3(1:lii3);
                        for k = 1:lii3                        % clusters in coin
                            cl1a=[cl1a,coin.coin(1,kkcoin(k))];
                            cl2a=[cl2a,coin.coin(2,kkcoin(k))];
                        end
                        [cl1,ia1,ic1]=unique(cl1a);
                        [cl2,ia2,ic2]=unique(cl2a);
                        unikkcoin1=kkcoin(ia1);
                        unikkcoin2=kkcoin(ia2);
                        
                        can1=[];
                        for k = 1:length(ia1)
                            kcl=coin.coin(1,unikkcoin1(k));
                            ini1=coin.indii1(1,kcl);
                            ifi1=coin.indii1(2,kcl); %size(cand1),ini1,ifi1
                            can1=[can1;cand1(ini1:ifi1,:)];
                        end
                        [ncan1,dum]=size(can1);
                        
                        can2=[];
                        for k = 1:length(ia2)
                            kcl=coin.coin(2,unikkcoin2(k));
                            ini2=coin.indii2(1,kcl);
                            ifi2=coin.indii2(2,kcl);
                            can2=[can2;cand2(ini2:ifi2,:)];
                        end
                        [ncan2,dum]=size(can2);
                        
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if kksour == 491
                            check91.cl1a=cl1a;
                            check91.cl2a=cl2a;
                            check91.unikkcoin1=unikkcoin1;
                            check91.unikkcoin2=unikkcoin2;
                            check91.can1=can1;
                            check91.can2=can2;
                        end
                        
                        if kksour == 492
                            check92.cl1a=cl1a;
                            check92.cl2a=cl2a;
                            check92.unikkcoin1=unikkcoin1;
                            check92.unikkcoin2=unikkcoin2;
                            check92.can1=can1;
                            check92.can2=can2;
                        end
                        
                        if kksour == 489
                            check89.cl1a=cl1a;
                            check89.cl2a=cl2a;
                            check89.unikkcoin1=unikkcoin1;
                            check89.unikkcoin2=unikkcoin2;
                            check89.can1=can1;
                            check89.can2=can2;
                        end
                        
                        if kksour == 494
                            check94.cl1a=cl1a;
                            check94.cl2a=cl2a;
                            check94.unikkcoin1=unikkcoin1;
                            check94.unikkcoin2=unikkcoin2;
                            check94.can1=can1;
                            check94.can2=can2;
                        end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        scoin=super_coin_source(ss(j,:),can1,can2,dmax,dfr,dsd);
                        
                        fprintf(' ncan1/2 %d  %d   d = %f \n',ncan1,ncan2,scoin.d)
                        
                        if scoin.d < 100000
                            fprintf(' scoin %d  d = %f  num1,num2 %d  %d  red %d %d lead=%d\n',k,scoin.d,ncan1,ncan2,...
                              scoin.ii1,scoin.ii2,scoin.lead)
                            ksc=ksc+1;
                            Scoin{ksc}=scoin;
                            nocs(noc,10)=ksc;
                        end
                        if scoin.d <= dmax
                            softinj_db(kksour,17)=2;
                            softinj_db(kksour,11)=scoin.cand(1);
                            softinj_db(kksour,12)=scoin.cand(2);
                            softinj_db(kksour,13)=scoin.cand(3);
                            softinj_db(kksour,14)=scoin.cand(4);
                            softinj_db(kksour,15)=scoin.cand(9);
                            softinj_db(kksour,16)=ss(j,6)*scoin.cand(9)/ss(j,5);
                            softinj_db(kksour,18)=1;
                            softinj_db(kksour,19)=1;
                            softinj_db(kksour,20)=1;
                            softinj_db(kksour,21)=1;
                            softinj_db(kksour,22)=num(1,jj);
                            softinj_db(kksour,23)=num(2,jj);
                            softinj_db(kksour,24)=scoin.d(1);
%                             softinj_db(kksour,25)=scoin.d(2);
%                             softinj_db(kksour,26)=scoin.d(3);
%                             softinj_db(kksour,27)=scoin.d(4);
%                             softinj_db(kksour,28)=scoin.d(5);

                            softinj_db(kksour,41)=scoin.cand1(1);
                            softinj_db(kksour,42)=scoin.cand1(2);
                            softinj_db(kksour,43)=scoin.cand1(3);
                            softinj_db(kksour,44)=scoin.cand1(4);
                            softinj_db(kksour,45)=scoin.cand1(9);
                            softinj_db(kksour,46)=ss(j,6)*scoin.cand1(9)/ss(j,5);

                            softinj_db(kksour,51)=scoin.cand2(1);
                            softinj_db(kksour,52)=scoin.cand2(2);
                            softinj_db(kksour,53)=scoin.cand2(3);
                            softinj_db(kksour,54)=scoin.cand2(4);
                            softinj_db(kksour,55)=scoin.cand2(9);
                            softinj_db(kksour,56)=ss(j,6)*scoin.cand2(9)/ss(j,5);
                            
                            ncoin=ncoin+1;
                            cs(ncoin,1)=ii(j);    % sour
                            cs(ncoin,2)=i;        % band
                            cs(ncoin,3)=jj;       % k in band
                            cs(ncoin,4)=scoin.cand(1);
                            cs(ncoin,5)=scoin.cand(2);
                            cs(ncoin,6)=scoin.cand(3);
                            cs(ncoin,7)=scoin.cand(4);
                            cs(ncoin,8)=scoin.cand(9);
                            cs(ncoin,9)=ss(j,5);  % sour h
                            cs(ncoin,10)=ss(j,6); % sour SNR
                            cs(ncoin,11)=0;
                            cs(ncoin,12)=0;
                            cs(ncoin,13)=0;
                            cs(ncoin,14)=0;
                            cs(ncoin,15)=num(1,jj);
                            cs(ncoin,16)=num(2,jj);
                            cs(ncoin,17)=2; % coincidence type
                            nocs(noc,11)=ncoin;
                            nocs(noc,10)=ksc;
                        end
                    end

                end
            end
        end
        ncointot=ncointot+liii;
        fprintf('band %d  sour %d  ncoin %d  d = %f  %f %f %f %f\n',i,j,length(iii),mind,d1(jj),d2(jj),d3(jj),d4(jj))
    end
    if check_typ == 2
        clear cand1 cand2
        eval(['clear ' VR2])
        eval(['clear ' VR4])
    end
end

outs=sim_soft_inj(softinj_db,1);
softinj_db(:,31)=softinj_db(:,16)./outs.v5nn;
% si_db(:,31)=si_db(:,16)./outs.vn;

sky_calib=data_an_pss.sky_calib_virgo;
xsk=x_gd(sky_calib);
ysk=y_gd(sky_calib);
b=abs(softinj_db(:,10));
b=interp1(xsk,ysk,b);
softinj_db(:,31)=softinj_db(:,16)./b./outs.v5nn;

cs=cs(1:ncoin,:);
nocs=nocs(1:noc,:);

duration=toc
savnam=sprintf('check_soft_inj_%04d%02d%02d_%02d%02d',vt(1:5))
save(savnam,'softinj_db','cs','nocs','Scoin','duration')

nsour1
ncoin,ncointot

snr=cs(:,10);
[ssnr,isnr]=sort(snr);

cs=cs(1:ncoin,:);
nocs=nocs(1:noc,:);
figure;semilogy(cs(:,4),cs(:,8),'.');
hold on,grid on,semilogy(cs(:,4),cs(:,9),'r.');title('b coin, r sour'),xlabel('Hz')

figure;semilogy(cs(:,4),snr,'.');title('coin: SNR vs fr'),grid on,xlabel('Hz')

gain=cs(:,8)./cs(:,9);
figure;loglog(snr,gain,'.');title('h_{det} / h_{inj}'),grid on,xlabel('snr')
xlim([0.3,100])

out=softinj_recal(cs);

D1=(sour0(cs(:,1),1)-cs(:,1+3))/dfr;
D2=(mod(sour0(cs(:,1),2),360)-cs(:,2+3))./cs(:,12);
D3=(sour0(cs(:,1),3)-cs(:,3+3))./cs(:,13);
D4=(sour0(cs(:,1),4)-cs(:,4+3))/dsd;

figure;semilogx(snr,D1,'.');title('d1 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(snr,D2,'.');title('d2 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(snr,D3,'.');title('d3 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(snr,D4,'.');title('d4 of coincidences'),grid on,xlabel('SNR')

figure,histogram(cs(:,11),40),grid on,title('d1 of coincidences'),xlabel('frequency natural step')
figure,histogram(cs(:,12),40),grid on,title('d2 of coincidences'),xlabel('lambda natural step')
figure,histogram(cs(:,13),0:0.1:4),grid on,title('d3 of coincidences'),xlabel('beta natural step')
figure,histogram(cs(:,14),40),grid on,title('d4 of coincidences'),xlabel('spin-down natural step')
d0=sqrt(cs(:,11).^2+cs(:,12).^2+cs(:,13).^2+cs(:,14).^2);
figure,histogram(d0,40),grid on,title('d of coincidences')

figure;semilogx(snr,cs(:,11),'.');title('d1'),grid on,xlabel('SNR')
figure;semilogx(snr,cs(:,12),'.');title('d2'),grid on,xlabel('SNR')
figure;semilogx(snr,cs(:,13),'.');title('d3'),grid on,xlabel('SNR')
figure;semilogx(snr,cs(:,14),'.');title('d4'),grid on,xlabel('SNR')

figure;loglog(snr,cs(:,15),'.');title('numerosity'),grid on
hold on,loglog(snr,cs(:,16),'r.'),xlabel('SNR')


figure;semilogy(nocs(:,4),nocs(:,8),'.');grid on,title('no-coin'),xlabel('Hz')
figure;semilogy(nocs(:,4),nocs(:,9),'ko'),xlabel('Hz')
hold on,semilogy(cs(:,4),snr,'r.');grid on,title('coin (r) and no-coin (k) SNR')

fprintf(' Big No-Coincidences Table \n\n')
ii=0;
for i = 1:noc
    if nocs(i,9) > 1
        ii=ii+1;
        fprintf('%3d  fr = %f  SNR = %f \n',ii,nocs(i,4),nocs(i,9));
    end
end

dxh=0.2;
xh=-1:dxh:2+dxh/2;
XH=10.^xh;
L10htot=log10(sour0(:,6));
htot=hist(L10htot,xh);
L10h=log10(cs(:,10));
h=hist(L10h,xh);
hno=hist(log10(nocs(:,9)),xh);
rat=h./(htot+0.01);
ratno=hno./(htot+0.01);
figure,stairs(xh,rat);grid on,title('efficiency (red % no coin)'),xlabel('SNR')
hold on,stairs(xh,ratno,'r');

nbin=15;
[hsnrtot,edg]=loghist(sour0(:,6),[0.1,100,nbin],1,2);
[hsnrcs,edg]=loghist(snr,[0.1,100,nbin],1,2);
[hsnrnocs,edg]=loghist(nocs(:,9),[0.1,100,nbin],1,2);
psnrcs=hsnrcs./(hsnrtot+0.01);
psnrnocs=hsnrnocs./(hsnrtot+0.01);
figure,stairs(edg,[psnrcs psnrcs(length(psnrcs))]),grid on
hold on,stairs(edg,[psnrnocs psnrnocs(length(psnrnocs))])
set(gca, 'XScale', 'log'),title('efficiency (red % no coin)'),xlabel('SNR')

out=sofinj_efficiency(sour1,cs,nocs);

md1=zeros(1,nbin);
md2=md1;
md3=md1;
md4=md1;
md=md1;
med1=md1;
med2=md1;
med3=md1;
med4=md1;
med=md1;

for i = 1:nbin
    ii=find(snr > edg(i) & snr <= edg(i+1));
    md1(i)=mean(cs(ii,11));
    md2(i)=mean(cs(ii,12));
    md3(i)=mean(cs(ii,13));
    md4(i)=mean(cs(ii,14));
    md(i)=mean(sqrt(cs(ii,11).^2+cs(ii,12).^2+cs(ii,13).^2+cs(ii,14).^2));
    med1(i)=median(cs(ii,11));
    med2(i)=median(cs(ii,12));
    med3(i)=median(cs(ii,13));
    med4(i)=median(cs(ii,14));
    med(i)=median(sqrt(cs(ii,11).^2+cs(ii,12).^2+cs(ii,13).^2+cs(ii,14).^2));
end

figure,stairs(edg,[md1 md1(nbin)]),set(gca, 'XScale', 'log')
grid on,title('freq uncertainty (red median)'),xlabel('SNR')
hold on,stairs(edg,[med1 med1(nbin)],'r'),xlim([edg(4),edg(nbin+1)])

figure,stairs(edg,[md2 md2(nbin)]),set(gca, 'XScale', 'log')
grid on,title('lambda uncertainty (red median)'),xlabel('SNR')
hold on,stairs(edg,[med2 med2(nbin)],'r'),xlim([edg(4),edg(nbin+1)])

figure,stairs(edg,[md3 md3(nbin)]),set(gca, 'XScale', 'log')
grid on,title('beta uncertainty (red median)'),xlabel('SNR')
hold on,stairs(edg,[med3 med3(nbin)],'r'),xlim([edg(4),edg(nbin+1)])

figure,stairs(edg,[md4 md4(nbin)]),set(gca, 'XScale', 'log')
grid on,title('spin-down uncertainty (red median)'),xlabel('SNR')
hold on,stairs(edg,[med4 med4(nbin)],'r'),xlim([edg(4),edg(nbin+1)])

figure,stairs(edg,[md md(nbin)]),set(gca, 'XScale', 'log')
grid on,title('full uncertainty (red median)'),xlabel('SNR')
hold on,stairs(edg,[med med(nbin)],'r'),xlim([edg(4),edg(nbin+1)])
