function out=fu_hfdf(cl_sosa,basic_info,enh,thr)
% hfdf for follow-up
%
%    fu_hfdf(sosa_cl,enh,thr)
%
%   cl_sosa          clean sosa (with rich cont)
%   basic_info       (important for run, epoch)
%   enh              enhacement follow-up factor (default 10)
%   thr              threshold (def sqrt(tfft2/tfft1)*1.75)
%
%   out
%      .basic_fu     basic_info enriched
%               .fu  follow-up parameters
%      .pm_          from fu_peakmap
%      .pm                 "
%      .cp_          from fu_crea_patches
%      .patches            "
%      .ppm          max of the peak frequency histogram for each patch
%      .cand         hough candidates for each patch
%      .candmax      the max amplitude hough candidate
%      .kpatch       the candmax patch number
%      .pmcorr       best patch peaks
%      .hfdf         best patch hough map
%      .sourout      corrected source
%      .cand2        the max ppm candidate
%      .kpatch2      its patch number
%      .pmcorr2      its patch peaks
%      .hfdf2        its hough map

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('enh','var')
    enh=10;
end
cont=cont_gd(cl_sosa);
dt=dx_gd(cl_sosa);
basic_info.frin=cont.limband(1);
basic_info.frfi=cont.limband(2);

epoch=basic_info.epoch;

sour=cont.sour;
sour_unc=struct();
[lamin,betin]=astro_coord('equ','ecl',sour.a,sour.d);

basic_fu=basic_info;
tfft1=basic_fu.run.fft.len*basic_fu.run.st;
sour_unc.f0=1/tfft1;
sour_unc.sd=basic_info.run.sd.dnat;
fftlen=ceil(0.5*tfft1*enh/dt)*2;
tfft2=fftlen*dt;
if ~exist('thr','var')
    thr=sqrt(tfft2/tfft1)*1.75;
    if enh == 1
        thr=2.5;
    end
end
disp(sprintf('  Threshold = %f',thr))
tfft=[tfft1 tfft2]; % CORREGGERE PER ULTERIORI STEP !

[pm out_pm]=fu_peakmap(cl_sosa,fftlen,cont.limband,thr);

fu_=pm.fu;
out.fu=fu_;

A(:,3)=pm.pm(3,:);
A(:,2)=pm.pm(2,:);
A(:,1)=pm.pm(1,:);
tits={sprintf('source at %f',cont.appf0),'MJD','Hz'};
color_points(A,0,tits);

[patches,out_cp]=fu_crea_patches(sour,tfft);
sour_unc.lam=out_cp.dlam;
sour_unc.bet=out_cp.dbet;

basic_fu.fu=out_pm.fu;
out.basic_fu=basic_fu;
% out.pm_=out_pm;
out.pm=pm.pm;
out.cp_=out_cp;
out.patches=patches;
out.nlams=length(out_cp.lams);
np=length(patches);
ppm=zeros(1,np);
pat_A=ppm;
pat_f=pat_A;
pat_sd=pat_A;
fu_info=struct();

hm_fu.oper='noadapt';

hm_fu.fr(1)=fu_.limband1(1)+fu_.fr0;
hm_fu.fr(2)=basic_info.run.fr.dnat/enh;
hm_fu.fr(3)=10;
hm_fu.fr(4)=fu_.limband1(2)+fu_.fr0;

hm_fu.sd(1)=-2*basic_info.run.sd.dnat;
hm_fu.sd(2)=basic_info.run.sd.dnat/enh;
hm_fu.sd(3)=4*ceil(enh)

sigband=2.5;
out.sigband=sigband;
fu_info.frlim=[sour.f0-sour_unc.f0*sigband sour.f0+sour_unc.f0*sigband];

cand=[];

for i = 1:np
    if floor(i/50)*50 == i
        fprintf('  %d patches  %s\n',i,datestr(now))
    end
    patch=patches(i,:);
    fu_info.patch=patch;
    peaks=fu_patch(pm,cont,patch);
    h=hist(peaks(2,:),5000);
    y=filter([0.5 0.5],1,h);
    ppm(i)=max(y);

    [ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
    if ierr > 0
        fprintf(' *** fu_hfdf error : ierr = %d  frq = %f \n',ierr,cont.sour.f0)
    end
    [cand1,fu_info]=hfdf_peak_1(hfdf,basic_info,fu_info);
    cand=[cand cand1];
    pat_A(i)=cand1(5);
    pat_f(i)=cand1(1);
    pat_sd(i)=cand1(4);
end

out.ppm=ppm;
out.pat_A=pat_A;
out.pat_f=pat_f;
out.pat_sd=pat_sd;

[amp,ii]=max(cand(5,:));
cand1=cand(:,ii);

out.cand=cand;
out.candmax=cand1;
lamout=lamin+cand1(2);
betout=betin+cand1(3);
[alfout,deltout]=astro_coord('ecl','equ',lamout,betout);

patch=patches(ii,:);
peaks=fu_patch(pm,cont,patch);
[ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
out.kpatch=ii;
out.pmcorr=peaks;
out.hfdf=hfdf;

sourout=sour;
sourout.a=alfout;
sourout.d=deltout;
sourout.f0=cand1(1);
sourout.df0=sour.df0+cand1(4);
sour.ecl=[lamin,betin];
out.sourin=sour;
out.sourin_unc=sour_unc;
out.sourout=sourout;

[appm,jj]=max(ppm);
out.cand2=cand(:,jj);
patch=patches(jj,:);
peaks=fu_patch(pm,cont,patch);
[ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
peaks=sd_corr_pm(peaks,cand1(4),epoch);
out.kpatch2=jj;
out.pmcorr2=peaks;
out.hfdf2=hfdf;