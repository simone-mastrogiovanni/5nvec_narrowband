function out=ana_softinj_sing(si_db_1,par,lev,fr,snr,typ)
% analysis of softinj_db_sing created by check_soft_inj_single
%
%    out=ana_softinj_sing(si_db_1,lev,fr,snr,typ)
%
%   si_db_1     softinj data-base 
%   par         .dfr1 .dfr2 .dsd1 .dsd2 (in par_ana_si)
%   lev         type of analyses
%   fr,snr,typ  selection (or absent, or 0; for typ [x0 x1 x2] 0 or 1)
%
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
% 30   d3
% 31   d4
% 32   precision snr

% Snag Version 2.0 - September 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[ndb,dum]=size(si_db_1);
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

ii=find(si_db_1(:,1) >= fr(1) & si_db_1(:,1) <= fr(2));
si_db_1=si_db_1(ii,:);

ii=find(si_db_1(:,6) >= snr(1) & si_db_1(:,6) <= snr(2));
si_db_1=si_db_1(ii,:);

% ii=find(typ(si_db_1(:,17)+1));
% si_db_1=si_db_1(ii,:);

[ndb1,dum]=size(si_db_1);
dd=zeros(ndb1,1);

out.ndb=ndb;
out.level=lev;
out.fr=fr;
out.snr=snr;
out.typ=typ;
out.si_db_1_sel=si_db_1;

figure,loglog(si_db_1(:,6),si_db_1(:,16),'.'),grid on
hold on,loglog(si_db_1(:,6),si_db_1(:,36),'r.')
xlabel('SNR_{inj}'),ylabel('SNR_{det}'),title('blue VSR2, red VSR4')

figure,loglog(si_db_1(:,6),si_db_1(:,17),'.'),grid on
hold on,loglog(si_db_1(:,6),si_db_1(:,37),'r.')
xlabel('SNR_{inj}'),ylabel('d'),title('distance - blue VSR2, red VSR4')

figure,plot(si_db_1(:,11)-si_db_1(:,1),si_db_1(:,31)-si_db_1(:,1),'.'); grid on

% sour1=
% for i = 1:ndb1
%     dd(i)=distance_4_sour(sour,cands,dfr,dsd)
% end