function out=fu_check_injection(sosa,basic_fu,enh,Source)
% 
%  out=fu_check_injection(sosa,basic_fu,enh,Source)
%
% es.: basic_fu=fu_struct.info1;
%      

% Snag version 2.0 - February 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome


    thresh=0.04;
    
cl_sosa=clean_sosa(sosa,thresh);

cont=cont_gd(cl_sosa);
dt=dx_gd(cl_sosa);
basic_fu.frin=cont.limband(1);
basic_fu.frfi=cont.limband(2);

epoch=basic_fu.epoch;

Source=new_posfr(Source,epoch);

sour=cont.sour;
sour_unc=struct();
[lamin,betin]=astro_coord('equ','ecl',sour.a,sour.d);

tfft1=basic_fu.run.fft.len*basic_fu.run.st;
sour_unc.f0=1/tfft1;
sour_unc.sd=basic_fu.run.sd.dnat;
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

% [patches,out_cp]=fu_crea_patches(sour,tfft);
% sour_unc.lam=out_cp.dlam;
% sour_unc.bet=out_cp.dbet;

basic_fu.fu=out_pm.fu;
out.basic_fu=basic_fu;
% out.pm_=out_pm;
out.pm=pm.pm;
% out.cp_=out_cp;
% out.patches=patches;
% out.nlams=length(out_cp.lams);
% np=length(patches);
% ppm=zeros(1,np);
% pat_A=ppm;
% pat_f=pat_A;
% pat_sd=pat_A;
fu_info=struct();

hm_fu.oper='noadapt';

hm_fu.fr(1)=fu_.limband1(1)+fu_.fr0;
hm_fu.fr(2)=basic_fu.run.fr.dnat/enh;
hm_fu.fr(3)=10;
hm_fu.fr(4)=fu_.limband1(2)+fu_.fr0;

hm_fu.sd(1)=-2*basic_fu.run.sd.dnat;
hm_fu.sd(2)=basic_fu.run.sd.dnat/enh;
hm_fu.sd(3)=4*ceil(enh)

fu_info.frlim=[sour.f0-sour_unc.f0*2 sour.f0+sour_unc.f0*2];

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
%     [hfdf,fu_info]=hfdf_hough(peaks,basic_fu,fu_info,hm_fu);
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

[Lam,Bet]=astro_coord('equ','ecl',Source.a,Source.d);
pat(1)=Lam-lamin;
pat(2)=Bet-betin;
fu_info.patch=pat;
[hfdf1,fu_info1]=hfdf_hough(pm.pm,basic_fu,fu_info,hm_fu);
peaks=fu_patch(pm,cont,pat);
[hfdf,fu_info]=hfdf_hough(peaks,basic_fu,fu_info,hm_fu);
[cand1,fu_info]=hfdf_peak_1(hfdf,basic_fu,fu_info);

peaks=sd_corr_pm(peaks,cand1(4),epoch);

out.pmcorr=peaks;
out.hfdf=hfdf;

figure,plot(pm.pm(1,:),pm.pm(2,:),'.'),grid on,hold on
plot(peaks(1,:),peaks(2,:),'r.'),title('raw and corrected')

plot(hfdf1),title('raw')
plot(hfdf),title('positionally corrected')


A(:,3)=peaks(3,:);
A(:,2)=peaks(2,:);
A(:,1)=peaks(1,:);
tits={sprintf('source at %f corrected',cont.appf0),'MJD','Hz'};
color_points(A,0,tits);

[wwh,outwh]=ww_hist(4,0.00001,pm.pm(2,:),pm.pm(3,:),1);
[wwhc,outwhc]=ww_hist(4,0.00001,out.pmcorr(2,:),out.pmcorr(3,:),1);

fig1=figure;plot(wwh);hold on,plot(wwhc,'r');xlabel('Hz')
out.fig1=fig1;

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
% [hfdf,fu_info]=hfdf_hough(peaks,basic_fu,fu_info,hm_fu);
% out.kpatch2=jj;
% out.pmcorr2=peaks;
% out.hfdf2=hfdf;