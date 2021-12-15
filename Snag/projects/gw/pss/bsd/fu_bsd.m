function out=fu_bsd(bsd_data,candsour,enh,ext_data)
% bsd follow-up for a hfdf candidate
%
%    out=fu_bsd(bsd_data,candsour,enh,thr,ext_data)
%
%    bsd_data    input bsd data
%    candsour    candidate source
%    enh         enhancement factor (on lfft)
%    ext_data    if external data are used
%                .tfft0  original tfft (s)
%                .pm     peak map
%                .sd_dnat
%                .fr_dnat
%                .peak_mode
%
% %    fu_hfdf(sosa_cl,enh,thr)
% %
% %   cl_sosa          clean sosa (with rich cont)
% %   basic_info       (important for run, epoch)
% %   enh              enhacement follow-up factor (default 10)
% %   thr              threshold (def sqrt(tfft2/tfft1)*1.75)
% %
% %   out
% %      .basic_fu     basic_info enriched
% %               .fu  follow-up parameters
% %      .pm_          from fu_peakmap
% %      .pm                 "
% %      .cp_          from fu_crea_patches
% %      .patches            "
% %      .ppm          max of the peak frequency histogram for each patch
% %      .cand         hough candidates for each patch
% %      .candmax      the max amplitude hough candidate
% %      .kpatch       the candmax patch number
% %      .pmcorr       best patch peaks
% %      .hfdf         best patch hough map
% %      .sourout      corrected source
% %      .cand2        the max ppm candidate
% %      .kpatch2      its patch number
% %      .pmcorr2      its patch peaks
% %      .hfdf2        its hough map

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio,S.Frasca,O.J.Piccinni - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('enh','var')
    enh=10;
end

cont=cont_gd(bsd_data);
tfstr0=cont.tfstr;
N=n_gd(bsd_data);
dt=dx_gd(bsd_data);
T0=N*dt;

if ~exist('ext_data','var')
    lfft0=tfstr0.lfft;
else
    lfft0=round(ext_data.tfft/dt);
end
lfft=enh*ext_data.lfft0;
t0=cont.t0;
sournew=new_posfr(candsour,t0)
fr=sournew.f0;
fr=[sournew.f0,sournew.df0,sournew.ddf0];

VPstr=extr_velpos_gd(bsd_data);
pO=interp_VP(VPstr,candsour);

bsd_data=vfs_subhet_pos(bsd_data,fr,pO);

gdpar=[dt,N];
sdpar=fr(2:length(fr));

sd=vfs_spindown(gdpar,sdpar,1);

bsd_data=vfs_subhet(bsd_data,sd);
tfstr=bsd_peakmap(bsd_data,lfft);

if ~exist('ext_data','var')
    fr_dnat=tfstr0.dfr;
    sd_dnat=fr_dnat/T0;
    peak_mode=2;
    hm_frenh=10;
else
    fr_dnat=ext_data.fr_dnat;
    sd_dnat=ext_data.sd_dnat;
    peak_mode=ext_data.peak_mode;
    hm_frenh=ext_data.hm_frenh;
end

frin=cont.inifr;
frfi=cont.inifr+cont.bandw;

basic_info.epoch=t0;  % ?????
basic_info.frin=frin;
basic_info.frfi=frfi;
basic_info.run.sd.dnat=sd_dnat;
basic_info.run.fr.dnat=fr_dnat;
basic_info.mode.peak_mode=peak_mode;
basic_info.mode.hm_job.frenh=hm_frenh;

sour=candsour;
sour_unc=struct();
[lamin,betin]=astro_coord('equ','ecl',sour.a,sour.d);

basic_fu=basic_info;
tfft1=lfft0*dt;
sour_unc.f0=1/tfft1;
sour_unc.sd=sd_dnat;
fftlen=lfft;
tfft2=fftlen*dt;




% % if ~exist('thr','var')
% %     thr=sqrt(tfft2/tfft1)*1.75;
% %     if enh == 1
% %         thr=2.5;
% %     end
% % end
% % disp(sprintf('  Threshold = %f',thr))
% tfft=[tfft1 tfft2]; % CORREGGERE PER ULTERIORI STEP !
% 
% % [pm out_pm]=fu_peakmap(bsd_data,fftlen,,thr);
% % 
% % fu_=pm.fu;
% % out.fu=fu_;
% % 
% % A(:,3)=pm.pm(3,:);
% % A(:,2)=pm.pm(2,:);
% % A(:,1)=pm.pm(1,:);
% % tits={sprintf('source at %f',cont.appf0),'MJD','Hz'};
% % color_points(A,0,tits);
% 
% [patches,out_cp]=fu_crea_patches(sour,tfft);
% sour_unc.lam=out_cp.dlam;
% sour_unc.bet=out_cp.dbet;
% 
% basic_fu.fu=out_pm.fu;
% out.basic_fu=basic_fu;
% % out.pm_=out_pm;
% out.pm=pm.pm;
% out.cp_=out_cp;
% out.patches=patches;
% out.nlams=length(out_cp.lams);
% np=length(patches);
% ppm=zeros(1,np);
% pat_A=ppm;
% pat_f=pat_A;
% pat_sd=pat_A;
% fu_info=struct();
% 
% hm_fu.oper='noadapt';
% 
% hm_fu.fr(1)=fu_.limband1(1)+fu_.fr0;
% hm_fu.fr(2)=basic_info.run.fr.dnat/enh;
% hm_fu.fr(3)=10;
% hm_fu.fr(4)=fu_.limband1(2)+fu_.fr0;
% 
% hm_fu.sd(1)=-2*basic_info.run.sd.dnat;
% hm_fu.sd(2)=basic_info.run.sd.dnat/enh;
% hm_fu.sd(3)=4*ceil(enh)
% 
% sigband=2.5;
% out.sigband=sigband;
% fu_info.frlim=[sour.f0-sour_unc.f0*sigband sour.f0+sour_unc.f0*sigband];
% 
% cand=[];
% 
% for i = 1:np
%     if floor(i/50)*50 == i
%         fprintf('  %d patches  %s\n',i,datestr(now))
%     end
%     patch=patches(i,:);
%     fu_info.patch=patch;
%     peaks=fu_patch(pm,cont,patch);
%     h=hist(peaks(2,:),5000);
%     y=filter([0.5 0.5],1,h);
%     ppm(i)=max(y);
% 
%     [ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
%     if ierr > 0
%         fprintf(' *** fu_hfdf error : ierr = %d  frq = %f \n',ierr,cont.sour.f0)
%     end
%     [cand1,fu_info]=hfdf_peak_1(hfdf,basic_info,fu_info);
%     cand=[cand cand1];
%     pat_A(i)=cand1(5);
%     pat_f(i)=cand1(1);
%     pat_sd(i)=cand1(4);
% end
% 
% out.ppm=ppm;
% out.pat_A=pat_A;
% out.pat_f=pat_f;
% out.pat_sd=pat_sd;
% 
% [amp,ii]=max(cand(5,:));
% cand1=cand(:,ii);
% 
% out.cand=cand;
% out.candmax=cand1;
% lamout=lamin+cand1(2);
% betout=betin+cand1(3);
% [alfout,deltout]=astro_coord('ecl','equ',lamout,betout);
% 
% patch=patches(ii,:);
% peaks=fu_patch(pm,cont,patch);
% [ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
% out.kpatch=ii;
% out.pmcorr=peaks;
% out.hfdf=hfdf;
% 
% sourout=sour;
% sourout.a=alfout;
% sourout.d=deltout;
% sourout.f0=cand1(1);
% sourout.df0=sour.df0+cand1(4);
% sour.ecl=[lamin,betin];
% out.sourin=sour;
% out.sourin_unc=sour_unc;
% out.sourout=sourout;
% 
% [appm,jj]=max(ppm);
% out.cand2=cand(:,jj);
% patch=patches(jj,:);
% peaks=fu_patch(pm,cont,patch);
% [ierr,hfdf,fu_info]=hfdf_hough_error_wrapper(peaks,basic_fu,fu_info,hm_fu);
% peaks=sd_corr_pm(peaks,cand1(4),epoch);
% out.kpatch2=jj;
% out.pmcorr2=peaks;
% out.hfdf2=hfdf;