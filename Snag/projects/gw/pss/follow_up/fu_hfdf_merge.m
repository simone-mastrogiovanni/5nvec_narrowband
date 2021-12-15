function out=fu_hfdf_merge(cl_sosa1,cl_sosa2,fu_struct,enh,thr)
% hfdf with merge for follow-up
%
%    fu_hfdf(sosa_cl,enh,thr)
%
%   cl_sosa1         clean sosa1 (with rich cont)
%   cl_sosa2         clean sosa2 similar to the sosa1, for second group
%   fu_struct        basic_fus
%   enh              enhacement follow-up factor (default 10)
%   thr              threshold (def sqrt(tfft2/tfft1)*1.75)
%
%   out
%      .basic_fu     basic_fu enriched
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

limhfdf=0.01; % Hz
enhsd=1;

if ~exist('enh','var')
    enh=10;
end
cont=cont_gd(cl_sosa1);
dt=dx_gd(cl_sosa1);

sour=cont.sour;
[lamin,betin]=astro_coord('equ','ecl',sour.a,sour.d);
sour.ecl=[lamin,betin];
sdin=sour.df0;

out.cont1=cont;
out.cont2=cont_gd(cl_sosa2);
out.info1=fu_struct.info1;
out.info2=fu_struct.info2;

basic_fu=fu_struct.info1;
basic_fu.frin=cont.limband(1);
basic_fu.frfi=cont.limband(2);

epoch=fu_struct.T0;

tfft1=basic_fu.run.fft.len*basic_fu.run.st;
fftlen=ceil(0.5*tfft1*enh/dt)*2;
tfft2=fftlen*dt;
out.dt=dt;
out.Tfft=tfft2;
if ~exist('thr','var')
    thr=sqrt(tfft2/tfft1)*1.75;
    if enh == 1
        thr=2.5;
    end
end
disp(sprintf('  Threshold = %f',thr))
tfft=[tfft1 tfft2]; % CORREGGERE PER ULTERIORI STEP !

out1=fu_hfdf(cl_sosa1,fu_struct.info1,enh,thr);
sourout1=out1.sourout;
unc1=out1.sourin_unc;
f1=sourout1.f0; % frequency at T1 estimated by group 1
pm1=out1.pm;
fu1=out1.fu;
out2=fu_hfdf(cl_sosa2,fu_struct.info2,enh,thr);
sourout2=out2.sourout;
unc2=out2.sourin_unc;
f2=sourout2.f0; % frequency at T2 estimated by group 1
pm2=out2.pm;
fu2=out2.fu;
sour_unc=unc1;
sour_unc.sd=(unc1.sd+unc2.sd)/2;

fu=fu1;
fu.tfu=[fu1.tfu; fu2.tfu];
fu.ttfu=[fu1.ttfu; fu2.ttfu];
fu.vfu=[fu1.vfu; fu2.vfu];
fu.vvfu=[fu1.vvfu; fu2.vvfu];
fu.wfu=[fu1.wfu; fu2.wfu];
out.fu=fu;

sd12=(f1-f2)/((fu_struct.T1-fu_struct.T2)*86400);

out.sd12=sd12;

% [pm1 out_pm1]=fu_peakmap(cl_sosa1,fftlen,cont.limband,thr);
% [pm2 out_pm2]=fu_peakmap(cl_sosa2,fftlen,cont.limband,thr);

[patches,out_cp]=fu_crea_patches(sour,tfft);

basic_fu.fu=out1.basic_fu.fu;
out.basic_fu=basic_fu;

pmraw=[pm1 pm2];
Tobs=max(pmraw(1,:))-min(pmraw(1,:));
dsd12=1/(Tobs*86400*tfft2);
out.dsd12=dsd12;
out.Tobs=Tobs;
out.pmraw=pmraw;
out.cp_=out_cp;
out.patches=patches;
out.nlams=length(out_cp.lams);
np=length(patches);
ppm=zeros(1,np);
pat_A=ppm;
pat_f=pat_A;
pat_sd=pat_A;
fu_info=struct();

A(:,3)=pmraw(3,:);
A(:,2)=pmraw(2,:);
A(:,1)=pmraw(1,:);
tits={sprintf('source at %f',cont.appf0),'MJD','Hz'};
color_points(A,0,tits);

hf_min=sour.f0-limhfdf/2;
hf_max=sour.f0+limhfdf/2;
ii=find(pmraw(2,:) > hf_min & pmraw(2,:) < hf_max);
pm.pm=pmraw(:,ii);
pm.fu=fu;
hm_fu.oper='noadapt';

hm_fu.fr(1)=hf_min;
hm_fu.fr(2)=basic_fu.run.fr.dnat/enh;
hm_fu.fr(3)=10;
hm_fu.fr(4)=hf_max;

% dsdori=(fu_struct.info1.sd.dnat+fu_struct.info2.sd.dnat)/2;
% sddnat=1/(Tobs*86400*tfft2);
n_sd=ceil(2*enh*enhsd)+7;
hm_fu.sd(2)=sour_unc.sd/(enh*enhsd);
hm_fu.sd(1)=-sour_unc.sd-3*hm_fu.sd(2);
hm_fu.sd(3)=n_sd

out.hm_fu=hm_fu;

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
        fprintf(' *** fu_hfdf_merge error : ierr = %d  frq = %f \n',ierr,cont.sour.f0)
    end
    [cand1,fu_info]=hfdf_peak_1(hfdf,basic_fu,fu_info);
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
betout=betin+cand1(3);lamout,betout
sdout=cand1(4)+sdin;
[alfout,deltout]=astro_coord('ecl','equ',lamout,betout);

patch=patches(ii,:);
peaks=fu_patch(pm,cont,patch);
[ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);

peaks=sd_corr_pm(peaks,cand1(4),epoch);

A1(:,3)=peaks(3,:);
A1(:,2)=peaks(2,:);
A1(:,1)=peaks(1,:);
tits={sprintf('source at %f corrected',cont.appf0),'MJD','Hz'};
color_points(A1,0,tits);

out.kpatch=ii;
out.pmcorr=peaks;
out.hfdf1=out1.hfdf;
out.hfdf2=out2.hfdf;
out.hfdf=hfdf;

sourout=sour;
sourout.a=alfout;
sourout.d=deltout;
sourout.ecl=[lamout,betout];
sourout.f0=cand1(1);
sourout.df0=sdout;
sour.ecl=[lamin,betin];
out.sourin=sour;
out.sourin_unc=sour_unc;
out.sourout1=sourout1;
out.sourout2=sourout2;
out.sourout=sourout;

% [appm,jj]=max(ppm);
% out.cand2=cand(:,jj);
% patch=patches(jj,:);
% peaks=fu_patch(pm,cont,patch);
% [hfdf,fu_info]=hfdf_hough(peaks,basic_fu,fu_info,hm_fu);
% out.kpatch2=jj;
% out.pmcorr2=peaks;
% out.hfdf2=hfdf;