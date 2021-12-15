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

% load C:\Users\SergioF\Documents\MATLAB\cand\coin_softinj\simsour_s\SOURCES_Sergio_new

tic
vt=datevec(now);
check_typ=2; 'FULL'
% check_typ=1; 'EASYFULL'
dcoin=1.8;
smallSNR=1.5;

ref_dir='C:\Users\SergioF\Documents\MATLAB\SoftInj2015\ref_softinj\';

nsour=500;
% nsour=418 % fino a 110 Hz
nbandmax=11;
% nbandmax=9 % fino a 110 Hz

% % hband=0.01; % max half band

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

ii=find(sour0(1:nsour,6) < maxsnr);
sour1=sour0(ii,:);

[nsour1,dum]=size(sour1);
cs=zeros(nsour1,17);
nocs=zeros(nsour1,11);
Scoin={};
ksc=0;

for i = 1:nbandmax % bands
    frin=(i+1)*10;
    frfi=frin+10;
    if i == 1
        frin=10;
    end
    ii=find(sour1(:,1) >= frin & sour1(:,1) <= frfi);
    ss=sour1(ii,:);
    lii=length(ii);
    str=sprintf('%03d%03d',frin,frfi);
    if check_typ == 2
        VR2=['VSR2_1_' str '_ref'];
        VR4=['VSR4_1_' str '_ref'];
        eval(['load ' ref_dir VR2 '.mat'])
        eval(['load ' ref_dir VR4 '.mat'])
        eval(['cand1=cand_corr(' VR2 ',coin);'])
        eval(['cand2=cand_corr(' VR4 ',coin);'])
    end
    eval(['coin=coin_1_' str '_C14_2;']);
    [fr,lam,bet,sd,A,h,d,num,dlam,dbet,clusts,cands,frmi,frma]=extr_coin_C14(coin);
    fr=fr(3,:);
    lam=lam(3,:);
    bet=bet(3,:);
    sd=sd(3,:);
    h=h(3,:);
%     DFR=sd*(epoch_coin-epoch_sour)*86400;
%     fr=fr-DFR;
    lam=mod(lam,360);
    dlam=(dlam(1,:)+dlam(2,:))/2;
    dbet=(dbet(1,:)+dbet(2,:))/2;
    nsc=0;
    
    for j = 1:lii   % sources
        Dbet=min(abs(bet-ss(j,3)),abs(-bet-ss(j,3)));
        lam1=mod(ss(j,2),360);
        Dlam=mod(abs(lam-lam1),360);
%         Dlam=abs(lam-lam1);
        d1=abs(ss(j,1)-fr)/dfr;
        d2=Dlam./dlam;
        d3=Dbet./dbet;
        d4=abs(ss(j,4)-sd)/dsd;
%         d=sqrt((abs(ss(j,1)-fr)/dfr).^2+(abs(ss(j,4)-sd)/dsd));
%         d=sqrt((abs(ss(j,1)-fr)/dfr).^2+(abs(ss(j,4)-sd)/dsd).^2+(Dlam./dlam).^2+(Dbet./dbet).^2);
%         d=sqrt(d2.^2+d3.^2);
        d=sqrt(d1.^2+d2.^2+d3.^2+d4.^2);
        iii=find(d <= dmax);
        [mind,jj]=min(d);
        liii=length(iii);
        if liii > 0
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
                            ifi1=coin.indii1(2,kcl);
                            can1=[can1;cand1(ini1:ifi1,:)];
                        end
                        [ncan1,dum]=size(can1);
                        
                        can2=[];
                        for k = 1:length(ia2)
                            kcl=coin.coin(1,unikkcoin2(k));
                            ini2=coin.indii2(1,kcl);
                            ifi2=coin.indii2(2,kcl);
                            can2=[can2;cand2(ini2:ifi2,:)];
                        end
                        [ncan2,dum]=size(can2);
                        
                        scoin=super_coin_source(ss(j,:),can1,can2,dmax,dfr,dsd);
                        
                        fprintf(' ncan1/2 %d  %d   d = %f \n',ncan1,ncan2,scoin.d)
                        
                        if scoin.d < 100000
                            fprintf(' scoin %d  d = %f  num1,num2 %d  %d  red %d %d lead=%d\n',k,scoin.d,length(clcan1(:,1)),length(clcan2(:,1)),...
                                scoin.ii1,scoin.ii2,scoin.lead)
                            ksc=ksc+1;
                            Scoin{ksc}=scoin;
                            nocs(noc,10)=ksc;
                        end
                        if scoin.d <= dmax
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

%                         kcl1=cl1(ia1);
%                         kcl2=cl2(ia2);
                        
%                         for k = 1:lii3    % clusters in coin
%                             kcoin=ii3(k);
%                             eval(['[clcan1,clcan2]=clusts_from_coin(' VR2 ',' VR4 ',coin,kcoin);'])
%                             [cc1,dum]=size(clcan1);
%                             [cc2,dum]=size(clcan2);
%                             ltot1=ltot1+cc1;
%                             ltot2=ltot2+cc2;
%                             scoin=super_coin_source(ss(j,:),clcan1,clcan2,dmax,dfr,dsd);
%                             ctot1=ctot1+scoin.ii1;
%                             ctot2=ctot2+scoin.ii2;
%                             mind1=min(mind1,scoin.mind1);
%                             mind2=min(mind2,scoin.mind2);
%                             if scoin.d < 100000
%                                 fprintf(' scoin %d  d = %f  num1,num2 %d  %d  red %d %d lead=%d\n',k,scoin.d,length(clcan1(:,1)),length(clcan2(:,1)),...
%                                     scoin.ii1,scoin.ii2,scoin.lead)
%                                 ksc=ksc+1;
%                                 Scoin{ksc}=scoin;
%                                 nocs(noc,10)=ksc;
%                             end
%                             if scoin.d <= dmax
%                                 ncoin=ncoin+1;
%                                 cs(ncoin,1)=ii(j);    % sour
%                                 cs(ncoin,2)=i;        % band
%                                 cs(ncoin,3)=jj;       % k in band
%                                 cs(ncoin,4)=scoin.cand(1);
%                                 cs(ncoin,5)=scoin.cand(2);
%                                 cs(ncoin,6)=scoin.cand(3);
%                                 cs(ncoin,7)=scoin.cand(4);
%                                 cs(ncoin,8)=scoin.cand(9);
%                                 cs(ncoin,9)=ss(j,5);  % sour h
%                                 cs(ncoin,10)=ss(j,6); % sour SNR
%                                 cs(ncoin,11)=0;
%                                 cs(ncoin,12)=0;
%                                 cs(ncoin,13)=0;
%                                 cs(ncoin,14)=0;
%                                 cs(ncoin,15)=num(1,jj);
%                                 cs(ncoin,16)=num(2,jj);
%                                 cs(ncoin,17)=2; % coincidence type
%                                 nocs(noc,11)=ncoin;
%                                 nocs(noc,10)=ksc;
%                             end
%                         end
                        
%                         fprintf('  ltot1/2 %d  %d     ctot1/2 %d  %d   mind1/2 %f  %f   lii3 %d\n',ltot1,ltot2,ctot1,ctot2,mind1,mind2,lii3)
%                     else
%                         fprintf('sour %d  no scoin  \n',ii(j))
%                     end
                end
            end
        end
        ncointot=ncointot+liii;
        fprintf('band %d  sour %d  ncoin %d  d = %f  %f %f %f %f\n',i,j,length(iii),mind,d1(jj),d2(jj),d3(jj),d4(jj))
    end
    if check_typ == 2
        eval(['clear ' VR2])
        eval(['clear ' VR4])
    end
end

cs=cs(1:ncoin,:);
nocs=nocs(1:noc,:);

duration=toc
savnam=sprintf('check_soft_inj_%04d%02d%02d_%02d%02d',vt(1:5))
save(savnam,'cs','nocs','Scoin','duration')

nsour1
ncoin,ncointot

cs=cs(1:ncoin,:);
nocs=nocs(1:noc,:);
figure;semilogy(cs(:,4),cs(:,8),'.');
hold on,grid on,semilogy(cs(:,4),cs(:,9),'r.');title('coin')

figure;semilogy(cs(:,4),cs(:,10),'.');title('coin: SNR vs fr'),grid on,xlabel('Hz')

figure;semilogy(cs(:,4),cs(:,8)./cs(:,9),'.');title('ratio'),grid on,xlabel('Hz')

D1=(sour0(cs(:,1),1)-cs(:,1+3))/dfr;
D2=(mod(sour0(cs(:,1),2),360)-cs(:,2+3))./cs(:,12);
D3=(sour0(cs(:,1),3)-cs(:,3+3))./cs(:,13);
D4=(sour0(cs(:,1),4)-cs(:,4+3))/dsd;

figure;semilogx(cs(:,10),D1,'.');title('d1 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(cs(:,10),D2,'.');title('d2 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(cs(:,10),D3,'.');title('d3 of coincidences'),grid on,xlabel('SNR')
figure;semilogx(cs(:,10),D4,'.');title('d4 of coincidences'),grid on,xlabel('SNR')

figure,hist(cs(:,11),40),grid on,title('d1 of coincidences')
figure,hist(cs(:,12),40),grid on,title('d2 of coincidences')
figure,hist(cs(:,13),40),grid on,title('d3 of coincidences')
figure,hist(cs(:,14),40),grid on,title('d4 of coincidences')
d0=sqrt(cs(:,11).^2+cs(:,12).^2+cs(:,13).^2+cs(:,14).^2);
figure,hist(d0,40),grid on,title('d of coincidences')

figure;semilogx(cs(:,10),cs(:,11),'.');title('d1'),grid on
figure;semilogx(cs(:,10),cs(:,12),'.');title('d2'),grid on
figure;semilogx(cs(:,10),cs(:,13),'.');title('d3'),grid on
figure;semilogx(cs(:,10),cs(:,14),'.');title('d4'),grid on

figure;loglog(cs(:,10),cs(:,15),'.');title('numerosity'),grid on
hold on,loglog(cs(:,10),cs(:,16),'r.')


figure;semilogy(nocs(:,4),nocs(:,8),'.');grid on,title('no-coin'),xlabel('Hz')
figure;semilogy(cs(:,4),cs(:,10),'r.');grid on,title('coin (r) and no-coin (k) SNR')
hold on,semilogy(nocs(:,4),nocs(:,9),'k.'),xlabel('Hz')

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
L10htot=log10(sour(:,6));
htot=hist(L10htot,xh);
L10h=log10(cs(:,10));
h=hist(L10h,xh);
hno=hist(log10(nocs(:,9)),xh);
rat=h./(htot+0.01);
ratno=hno./(htot+0.01);
figure,stairs(xh,rat);grid on,title('efficiency (red % no coin)'),xlabel('SNR')
hold on,stairs(xh,ratno,'r');

nxh=length(xh);
md1=zeros(1,nxh);
md2=md1;
md3=md1;
md4=md1;
med1=md1;
med2=md1;
med3=md1;
med4=md1;

for i = 1:nxh
    ii=find(L10h >= xh(i)-dxh/2 & L10h < xh(i)+dxh/2);
    md1(i)=mean(cs(ii,11));
    md2(i)=mean(cs(ii,12));
    md3(i)=mean(cs(ii,13));
    md4(i)=mean(cs(ii,14));
    med1(i)=median(cs(ii,11));
    med2(i)=median(cs(ii,12));
    med3(i)=median(cs(ii,13));
    med4(i)=median(cs(ii,14));
end

figure,stairs(xh,md1),grid on,title('freq uncertainty (red median)'),xlabel('log10(SNR)')
hold on,stairs(xh,med1,'r')
figure,stairs(xh,md2),grid on,title('lam uncertainty (red median)'),xlabel('log10(SNR)')
hold on,stairs(xh,med2,'r')
figure,stairs(xh,md3),grid on,title('bet uncertainty (red median)'),xlabel('log10(SNR)')
hold on,stairs(xh,med3,'r')
figure,stairs(xh,md4),grid on,title('sd uncertainty (red median)'),xlabel('log10(SNR)')
hold on,stairs(xh,med4,'r')

% disp(' *** ERRORE !')
% figure,plot(dbet,'.'),title(' *** dbeta !'),grid on