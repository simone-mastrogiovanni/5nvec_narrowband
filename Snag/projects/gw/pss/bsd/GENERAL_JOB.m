function [job_info,job_summary,check]=GENERAL_JOB(direct,bsdin,mod)
% 
%    direct   direction structure (no f0,df0,ddf0 and fepoch)
%    bsdin    input bsd
%    mod      mode (from bsd_mode modified)

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
job_summary=struct();
direct.df0=0;
direct.ddf0=0;
bsdcor=bsd_dopp_sd(bsdin,direct,0);

cont=ccont_gd(bsdcor);
n=n_gd(bsdcor);
dt=dx_gd(bsdcor);

parin.enh=1;
job_info.enh=parin.enh;

parin.direct=direct;
par=bsd_par(bsdcor,parin);
lfft=par.lfft; %n,dt,lfft

tfstr=bsd_peakmap(bsdcor,lfft);
check.peaks=tfstr.pt.peaks; % !!!

VPstr=extr_velpos_gd(bsdcor);
Tvel_pt=tfstr.pt.tpeaks; 
[p,v,t,dp,dv]=interp_VP(VPstr,direct,Tvel_pt);

tfstr.dir_par=par; %save('tfstrfil','tfstr')

peaks_par=tfstr;
peaks_par.Tvel_pt=Tvel_pt;
peaks_par.vdirect=v;
peaks_par.dvdirect=dv;
peaks_par.pt=rmfield(peaks_par.pt,'peaks')

proc_info.bsdcont=cont;
proc_info.comp='normal';
proc_info.peaks_par=peaks_par;
proc_info.epoch=cont.t0+n*dt/(2*86400);
proc_info.hm.fr(1)=cont.inifr;
proc_info.hm.fr(2)=1/par.tfft;
proc_info.hm.fr(3)=10;
proc_info.hm.fr(4)=cont.inifr+cont.bandw;
proc_info.hm.oper='noiseadapt';
% proc_info.hm.oper='noadapt';
proc_info.hm.sd(1)=-par.dsd0*10;
% proc_info.hm.sd(1)=-par.dsd0*300;
proc_info.hm.sd(2)=par.dsd0
proc_info.hm.sd(3)=14;
% proc_info.hm.sd(3)=302;

proc_info.peak_mode=2;

job_info.type='direct'; %%
if ~isfield(direct,'lam')
    direct.lam=par.lam;
    direct.bet=par.bet;
end
job_info.patch(1)=direct.lam;
job_info.patch(2)=direct.bet;
job_info.patch(3)=par.ulam*2;
job_info.patch(4)=direct.bet+par.ubet*2;
job_info.patch(5)=direct.bet-par.ubet*2;

kcand=300;

toc

% [hmap,job_info,checkE]=bsd_hough(3,tfstr.pt.peaks,proc_info,job_info);
[hmap,job_info,checkE]=bsd_hough(1,tfstr.pt.peaks,proc_info,job_info);

check.checkE=checkE;
check.hmap=hmap;
check.job_info=job_info;
toc

[cand,job_info,checkF]=bsd_cand(hmap,proc_info,job_info,kcand);

job_info.proc_info=proc_info;

check.cand=cand;
% check.job_info=job_info;

toc