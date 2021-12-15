function [job_info,job_summary,check]=DIRECT_JOB(direct,bsdin,addr,tab)
% creation of the hough maps for direct 
%
%   direct   direction structure
%   bsdin    input bsd or access structure (.tim,.fr)
%   addr     bsd folder address
%   tab      table

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
job_summary=struct();
if isstruct(bsdin)
    [tab_out,epoch0,maxt]=bsd_extr_subtab(tab,bsdin.tim,bsdin.fr);
    icmult=1;
%     N=height(tab_out);
    N=length(tab_out);
else
    icmult=0;
    N=1;
end

proc_info.epoch=epoch0;

if icmult == 1
    proc_info.Tmax_sd=maxt
else
    proc_info.Tmax_sd=86400*31/2
end

for k = 1:N
    if icmult == 1
        [bsdin, name]=load_tab_bsd(addr,tab_out,k);
        name
    end
    
    if k == 1
        cont0=ccont_gd(bsdin);
        eval(['job_info.ant=' cont0.ant ';'])
    end
    
    bsdcor=bsd_multi_dopp(bsdin,direct);

    cont=ccont_gd(bsdcor);
    n=n_gd(bsdcor);
    dt=dx_gd(bsdcor);

    parin.enh=4;
    job_info.enh=parin.enh;

    parin.direct=direct;
    par=bsd_par(bsdcor,parin);
    lfft=par.lfft; %n,dt,lfft

    tfstr=bsd_peakmap(bsdcor,lfft);
    check.peaks=tfstr.pt.peaks; % !!!

    VPstr=extr_velpos_gd(bsdcor);
    Tvel_pt=tfstr.pt.tpeaks; 
    [p,v,dp,dp,dv]=interp_VP(VPstr,direct,Tvel_pt);

    tfstr.dir_par=par; %save('tfstrfil','tfstr')

    peaks_par=tfstr;
    peaks_par.Tvel_pt=Tvel_pt;
    peaks_par.vdirect=v;
    peaks_par.dvdirect=dv;
    peaks_par.pt=rmfield(peaks_par.pt,'peaks')

    proc_info.bsdcont=cont;
    proc_info.peaks_par=peaks_par;
    
    if k == 1
        proc_info.comp='normal';
        proc_info.hm.fr(1)=cont.inifr;
        proc_info.hm.fr(2)=1/par.tfft;
        proc_info.hm.fr(3)=10;
        proc_info.hm.fr(4)=cont.inifr+cont.bandw;
        proc_info.hm.oper='noiseadapt';
        proc_info.hm.oper='noadapt';
        proc_info.hm.oper='adapt';
        proc_info.hm.sd(1)=-par.dsd0*10;
        % proc_info.hm.sd(1)=-par.dsd0*300;
        proc_info.hm.sd(2)=par.dsd0
        proc_info.hm.sd(3)=12;
        % proc_info.hm.sd(3)=302;

        proc_info.peak_mode=2;
    end

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

    kcand=300; proc_info

    toc
    
    [peaks,job_info,checkD]=bsd_patch(tfstr.pt.peaks,job_info);
    
    [hmap,job_info,checkE]=bsd_hough(4,peaks,proc_info,job_info);
    
    if k == 1
        Hmap=hmap;
    else
        Hmap=Hmap+hmap;
    end
end

job_info.proc_info=proc_info;

check.checkE=checkE;
check.hmap=Hmap;
check.job_info=job_info;
toc

[cand,job_info,checkF]=bsd_cand(Hmap,proc_info,job_info,kcand);

check.checkF=checkF;
check.cand=cand;

% check.job_info=job_info;

toc