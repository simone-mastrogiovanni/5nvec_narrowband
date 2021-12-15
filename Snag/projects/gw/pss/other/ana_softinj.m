function out=ana_softinj(si_db,lev,fr,snr,typ)
% analysis of softinj db
%
%    out=ana_softinj(si_db,lev,fr,snr,typ)
%
%   si_db       softinj data-base
%   lev         type of analyses
%   fr,snr,typ  selection (or absent, or 0; for typ [x0 x1 x2] 0 or 1)
%
% softinj_db(n,60):
%
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
% 47   A
%         Second set
% 51   fr
% 52   lam
% 53   bet
% 54   sd
% 55   h
% 56   SNR
% 57   A

% Snag Version 2.0 - July 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[ndb,dum]=size(si_db);
if ~exist('lev','var')
    lev=1;
end

if ~exist('fr','var')
    fr=[0 10000];
end

if ~exist('snr','var')
    snr=[0 1e10];
end

if ~exist('typ','var')
    typ=[1 1 1];
end

if length(fr) == 1
    fr=[0 10000];
end

if length(snr) == 1
    snr=[0 1e10];
end

if length(typ) == 1
    typ=[1 1 1];
end

ii=find(si_db(:,1) >= fr(1) & si_db(:,1) <= fr(2));
si_db=si_db(ii,:);

ii=find(si_db(:,6) >= snr(1) & si_db(:,6) <= snr(2));
si_db=si_db(ii,:);

ii=find(typ(si_db(:,17)+1));
si_db=si_db(ii,:);

[ndb1,dum]=size(si_db);

out.ndb=ndb;
out.level=lev;
out.fr=fr;
out.snr=snr;
out.typ=typ;
out.si_db_sel=si_db;

fr1=si_db(:,1);
lam1=si_db(:,2);
bet1=si_db(:,3);
sd1=si_db(:,4);
h1=si_db(:,5);
snr1=si_db(:,6);
eta=si_db(:,7);
psi=si_db(:,8);
apha=si_db(:,9);
delta=si_db(:,10);
fr2=si_db(:,11);
lam2=si_db(:,12);
bet2=si_db(:,13);
sd2=si_db(:,14);
h2=si_db(:,15);
snr2=si_db(:,16);
typ2=si_db(:,17);
clu1=si_db(:,18);
can1=si_db(:,19);
clu2=si_db(:,20);
can2=si_db(:,21);
num1=si_db(:,22);
num2=si_db(:,23);
d=si_db(:,24);
d1=si_db(:,25);
d2=si_db(:,26);
d3=si_db(:,27);
d4=si_db(:,28);
snr3=si_db(:,31);

h_1=si_db(:,45);
h_2=si_db(:,55);

A_1=si_db(:,47);
A_2=si_db(:,57);

% detection

ii0=find(typ2 == 0);
ii1=find(typ2 == 1);
ii2=find(typ2 == 2);
ii12=find(typ2 > 0);
figure,semilogy(fr1(ii1),snr1(ii1),'o'),grid on,hold on
semilogy(fr1(ii2),snr1(ii2),'go'),semilogy(fr1(ii0),snr1(ii0),'ro')
xlabel('Hz'),ylabel('SNR'),title('b detected, g det. type II, r not detected')
xlim([20 128])

figure,semilogy(fr1(ii1),h1(ii1),'o'),grid on,hold on
semilogy(fr1(ii2),h1(ii2),'go'),semilogy(fr1(ii0),h1(ii0),'ro')
xlabel('Hz'),ylabel('h'),title('b detected, g det. type II, r not detected')
xlim([20 128])

figure,semilogy(fr1(ii12),snr1(ii12),'o'),grid on,hold on
semilogy(fr1(ii0),snr1(ii0),'ro')
xlabel('Hz'),ylabel('SNR'),title('b detected, r not detected')
xlim([20 128])

figure,semilogy(fr1(ii12),h1(ii12),'o'),grid on,hold on
semilogy(fr1(ii0),h1(ii0),'ro')
xlabel('Hz'),ylabel('h'),title('b detected, r not detected')
xlim([20 128])

% distance

ii=find(typ2>0);
figure,semilogx(snr1(ii),d(ii),'.'),grid on
title('Distance vs snr'),xlabel('snr'),ylabel('d')

figure,semilogx(snr1(ii),d1(ii),'.'),grid on,hold on
semilogx(snr1(ii),d2(ii),'r.'),semilogx(snr1(ii),d3(ii),'g.'),semilogx(snr1(ii),d4(ii),'k.')
title('b d1, r d2, g d3, k d4'),xlabel('snr'),ylabel('d')

xd=0:0.1:4;
figure,hd=histogram(d(ii),xd);title('Distance histogram'),xlabel('d')
out.ndb_sel=ndb1;

% snr

ii=find(typ2>0);
figure,loglog(snr1(ii),snr2(ii),'.'),grid on
hold on,loglog(snr1(ii),snr3(ii),'r.')
title('Det-snr vs Inj-snr'),xlabel('Inj.snr'),ylabel('Det.snr')

out.eff=sofinj_efficiency(si_db);

ii=find(snr2);
figure,plot(delta(ii),snr2(ii)./snr1(ii),'.'),grid on,title('delta')
figure,plot(eta(ii),snr2(ii)./snr1(ii),'.'),grid on,title('eta')

% single run

ii=find(typ2>0);
figure,loglog(h_1(ii),h_2(ii),'.');
xlabel('h_1'),ylabel('h_2'),grid on

figure,semilogy(fr1(ii),h_2(ii)./h_1(ii),'.');
xlabel('Hz'),ylabel('h_2/h_1'),grid on,xlim([20 128])

% A

% figure,plot(snr1(ii),A_1(ii),'.'),hold on,grid on,plot(snr1(ii),A_2(ii),'r.')
figure,loglog(snr1(ii),A_1(ii),'.'),hold on,grid on,loglog(snr1(ii),A_2(ii),'r.')

out.snr1=snr1(ii);
out.A_1=A_1(ii);
out.A_2=A_2(ii);

% wwh=ww_hist(1,0.1,log10(snr1),0,1);
% wwh1=ww_hist(1,0.2,log10(snr1),log10(A_1),1);
% wwh2=ww_hist(1,0.2,log10(snr1),log10(A_2),1);
% 
% figure,loglog(x_gd(wwh1),10.^y_gd(wwh1)),hold on,grid on,loglog(x_gd(wwh2),10.^y_gd(wwh2))