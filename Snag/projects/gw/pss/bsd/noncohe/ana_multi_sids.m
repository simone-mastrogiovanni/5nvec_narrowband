function [anas,selfr]=ana_multi_sids(sids,typ)
% analysis of multi_sids
%   
%   sids    multi_sid output cell array
%   typ     type of analysis
%            0   base
%            1   selfr  (def)

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=1;
end
n=length(sids);
nant=n-1;

for k = 1:nant
    anas(k).type=sids{k}.ant;
    anas(k).Sigs=log10(sids{k}.sidsig)/4;
    anas(k).Nois=log10(sids{k}.sidnois)/4;
    anas(k).mu_s=mean(anas(k).Sigs);
    anas(k).sd_s=std(anas(k).Sigs);
    anas(k).max_s=max(anas(k).Sigs);
    anas(k).snr_s=(anas(k).max_s-anas(k).mu_s)/anas(k).sd_s;
    anas(k).mu_n=mean(anas(k).Nois);
    anas(k).sd_n=std(anas(k).Nois);
    anas(k).max_n=max(anas(k).Nois);
    [sig_h,xsig_h]=hist(anas(k).Sigs,200);
    anas(k).sig_h=sig_h;
    anas(k).sig_xh=xsig_h;
    [nois_h,xnois_h]=hist(anas(k).Nois,200);
    anas(k).nois_h=nois_h;
    anas(k).nois_xh=xnois_h;
    prank=sort_p_rank(anas(k).Sigs);
    robprank=sort_p_rank(anas(k).Sigs-anas(k).Nois);
    if k == 1
        signorm=1/anas(k).sd_s^2;
        SSig=(anas(k).Sigs-anas(k).mu_s)/anas(k).sd_s^2;
        NNois=anas(k).Nois;
        robSSig0=anas(k).Sigs-anas(k).Nois;
        robSSig=(robSSig0-mean(robSSig0))/std(robSSig0)^2;
        robsignorm=1/std(robSSig0)^2;
        PRank=prank;
        robPRank=robprank;
    else
        signorm=signorm+1/anas(k).sd_s^2;
        SSig=SSig+(anas(k).Sigs-anas(k).mu_s)/anas(k).sd_s^2;
        NNois=NNois+anas(k).Nois;
        robSSig0=anas(k).Sigs-anas(k).Nois;
        robSSig=robSSig+(robSSig0-mean(robSSig0))/std(robSSig0)^2;
        robsignorm=robsignorm+1/std(robSSig0)^2;
        PRank=prank.*PRank;
        robPRank=robprank.*robPRank;
    end
    figure,semilogy(xsig_h,sig_h),grid on,title(['sid sig hist for ' anas(k).type])
    g=hist_gaus_fit(sig_h,xsig_h);
    hold on,semilogy(xsig_h,g,'g'),ylim([1,1.1*max([g])])
    figure,semilogy(xnois_h,nois_h),grid on,title(['sid nois hist for ' anas(k).type])
    g=hist_gaus_fit(nois_h,xnois_h);
    hold on,semilogy(xnois_h,g,'m'),ylim([1,1.1*max([g])])
end

anas(n).type='product';
anas(n).Sigs=SSig/signorm;
[sig_h,xsig_h]=hist(anas(n).Sigs,200);
anas(n).sig_h=sig_h;
anas(n).sig_xh=xsig_h;
figure,semilogy(xsig_h,sig_h),grid on,title(['sid sig hist for ' anas(n).type])
g=hist_gaus_fit(sig_h,xsig_h);
hold on,semilogy(xsig_h,g,'m'),ylim([1,1.1*max([g])])

anas(n).Nois=NNois/2;
[nois_h,xnois_h]=hist(anas(n).Nois,200);
anas(n).nois_h=nois_h;
anas(n).nois_xh=xnois_h;
figure,semilogy(xnois_h,nois_h),grid on,title(['sid nois hist for ' anas(n).type])
g=hist_gaus_fit(nois_h,xnois_h);
hold on,semilogy(xnois_h,g,'g'),ylim([1,1.1*max([g])])

anas(n).mu_s=mean(anas(n).Sigs);
anas(n).sd_s=std(anas(n).Sigs);
anas(n).max_s=max(anas(n).Sigs);
anas(n).snr_s=(anas(n).max_s-anas(n).mu_s)/anas(n).sd_s;
anas(n).mu_n=mean(anas(n).Nois);
anas(n).sd_n=std(anas(n).Nois);
anas(n).max_n=max(anas(n).Nois);

anas(n+1).type='robust';
anas(n+1).Sigs=robSSig/robsignorm;

[sig_h,xsig_h]=hist(anas(n+1).Sigs,200);
anas(n+1).sig_h=sig_h;
anas(n+1).sig_xh=xsig_h;
figure,semilogy(xsig_h,sig_h),grid on,title(['sid sig hist for ' anas(n+1).type])
g=hist_gaus_fit(sig_h,xsig_h);
hold on,semilogy(xsig_h,g,'g'),ylim([1,1.1*max([g])])

anas(n+1).mu_s=mean(anas(n+1).Sigs);
anas(n+1).sd_s=std(anas(n+1).Sigs);
anas(n+1).max_s=max(anas(n+1).Sigs);
anas(n+1).snr_s=(anas(n+1).max_s-anas(n+1).mu_s)/anas(n+1).sd_s;

anas(n+2).type='ranking';
anas(n+2).Sigs=-log10(PRank);
[sig_h,xsig_h]=hist(anas(n+2).Sigs,200);
anas(n+2).sig_h=sig_h;
anas(n+2).sig_xh=xsig_h;
[g,pars]=hist_rank_fit(sig_h,xsig_h,nant);
title(['sid sig hist for ' anas(n+2).type])

figure,plot(sids{1}.fr,anas(n+2).Sigs,'.'),grid on,title('ranking')

anas(n+2).mu_s=mean(anas(n+2).Sigs);
anas(n+2).sd_s=std(anas(n+2).Sigs);
anas(n+2).max_s=max(anas(n+2).Sigs);
anas(n+2).snr_s=(anas(n+2).max_s-anas(n+2).mu_s)/anas(n+2).sd_s;

anas(n+3).type='rob-ranking';
anas(n+3).Sigs=-log10(robPRank);

hold on,plot(sids{1}.fr,anas(n+3).Sigs,'r.'),grid on,title('Ranking and rob-ranking (r)')

[sig_h,xsig_h]=hist(anas(n+3).Sigs,200);
anas(n+3).sig_h=sig_h;
anas(n+3).sig_xh=xsig_h;
[g,pars]=hist_rank_fit(sig_h,xsig_h,nant);
title(['sid sig hist for ' anas(n+3).type])

anas(n+3).mu_s=mean(anas(n+3).Sigs);
anas(n+3).sd_s=std(anas(n+3).Sigs);
anas(n+3).max_s=max(anas(n+3).Sigs);
anas(n+3).snr_s=(anas(n+3).max_s-anas(n+3).mu_s)/anas(n+3).sd_s;

figure,plot(sids{1}.fr,anas(n).Sigs,'.')
hold on,plot(sids{1}.fr,anas(n+1).Sigs,'r.'),grid on,title('product & robust (r)')

% if nargout > 1 & typ == 1
if typ == 1
    msgbox('zoom, key press and select')
    pause()
    [selfr,~] = ginput(2)
else
    selfr=0;
end