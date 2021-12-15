function [spotstr,job_info,job_summary,check]=FOLLOWUP_JOB(candstr,bsdin,mod)
% 
%   candstr      cand
%                tfft
%                coincidence epoch
%                for each antenna
%                 cand0
%                 cluster info
%                 hough epoch
%
%    bsdin       input bsd
%    mod         mode (from bsd_mode modified)

% Snag Version 2.0 - March 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic

job_summary=struct();
targ=cand2sour(candstr.cand,candstr.epoch);

if iscell(bsdin)
    bsdins=bsdin;
    ncell=length(bsdin);
else
    ncell=1;
end

proc_info=mod;
proc_info.fu.cand=candstr;
        
thr=mod.fu.thr;

tfft0=candstr.tfft;

for i = 1:ncell
    if ncell > 1
        bsdin=bsdins{i};
    end
    
    [bsdcor,frcorr]=bsd_dopp_sd(bsdin,targ);

    cont=ccont_gd(bsdcor);
    n=n_gd(bsdcor);
    dt=dx_gd(bsdcor);
    
    if i == 1
        proc_info.t0=cont.t0;
        parin.candstr=candstr;
        par=bsd_par(bsdcor,parin);
        dt=dx_gd(bsdcor);
        lfft0=round(tfft0/dt);

        lfft=mod.fu.fftgain*lfft0;
        lfft=round(lfft/4)*4;
        proc_info.fu.lfft=lfft;
        if mod.hm.mode == 1
            proc_info.hm.fr(1)=cont.inifr;
            proc_info.hm.fr(2)=1/par.tfft;
            proc_info.hm.fr(3)=10;
            proc_info.hm.fr(4)=cont.inifr+cont.bandw;
            proc_info.hm.sd(1)=-par.dsd0*17;
            proc_info.hm.sd(2)=par.dsd0
            proc_info.hm.sd(3)=20;
            proc_info.hm.oper='noiseadapt';
        end
        proc_info.epoch=candstr.epoch;
    end

    % parin.direct=direct;
    % par=bsd_par(bsdcor,parin);
    % lfft=par.lfft; %n,dt,lfft

    tfstr=bsd_peakmap(bsdcor,lfft,thr);
%     tfstr.pt.peaks=clean_persist(tfstr.pt.peaks,tfstr.t0,frcorr,pers,dt,dfr); DA CONTROLLARE
    
%     check.peaks=tfstr.pt.peaks; % !!!

    VPstr=extr_velpos_gd(bsdcor);
    Tvel_pt=tfstr.pt.tpeaks; 
    [p,v,t,dp,dv]=interp_VP(VPstr,targ,Tvel_pt); check.p=p;check.v=v;check.dp=dp;check.dv=dv;

    tfstr.dir_par=par; %save('tfstrfil','tfstr')

    peaks_par=tfstr;
    peaks_par.Tvel_pt=Tvel_pt;
    peaks_par.vdirect=v;
    peaks_par.dvdirect=dv;
    peaks_par.pt=rmfield(peaks_par.pt,'peaks')
    proc_info.peaks_par=peaks_par;

    job_info.type='followup'; %%
    
    job_info.patch(1)=targ.lam;
    job_info.patch(2)=targ.bet;
    job_info.patch(3)=par.ulam*2;
    job_info.patch(4)=targ.bet+par.ubet*2;
    job_info.patch(5)=targ.bet-par.ubet*2;
    patch(1)=targ.lam;
    patch(2)=targ.bet;
    patch(3)=par.ulam*2;
    patch(4)=targ.bet+par.ubet*2;
    patch(5)=targ.bet-par.ubet*2;

    toc
 
%     check.job_info=job_info;
%     candout=0;
%     return
    size(tfstr.pt.peaks);
    [spotstr,job_info,checkG]=bsd_hspot(3,candstr.cand,proc_info,job_info,tfstr.pt.peaks,patch);
    spotstr.peaks_par=peaks_par;
    candout=spotstr.candout;
    
%     [hmap,job_info,checkE]=bsd_hough(3,tfstr.pt.peaks,proc_info,job_info);
%     [hmap,job_info,checkE]=bsd_hough(1,tfstr.pt.peaks,proc_info,job_info);

%     check.checkE=checkE;
%     check.hmap=hmap;

    job_info.proc_info=proc_info;

    check.job_info=job_info;
    check.checkG=checkG;
    toc

%     [candout,job_info,checkF]=bsd_cand(hmap,proc_info,job_info,mod.fu.ncand);
    
    if ncell > 1
        ccandout{i}=candout;
    end
end

if ncell > 1
    candout=ccandout;
end

[n1,n2]=size(candout);

for i = 1:n2
    candout(1:9,i)=candstr.cand;
end

spotstr.cont=cont;
spotstr.candout=candout;
% check.job_info=job_info;

toc