function [cand,job_summary,check]=HFDF_JOB_2016(job_pack_0,job_pack,outdir)
% HFDF  single job operation on a node
%
%   job_pack_0   the structure containing the basic_info and the peak table
%                  or the name of the mat file that contains it
%   job_pack     the structure containing the patches with which the job should work
%                  or the name of the mat file that contains it
%      if this variable are absent, the job_data.txt file is opened to read 
%      the name of matfiles to be opened
%   outdir       output fo;der, with final separator
%
% The candidate matrix cand and the structure job_summary are saved on disk
% as m-files

% Version 2.0 - November 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

tic0=tic;
tim0=datestr(now);
check=struct();

if ~exist('job_pack_0','var')
    id=fopen('job_data.txt','r');
    job_pack_0=fscanf(id,'%s');
    job_pack=fscanf(id,'%s');
end
if ischar(job_pack_0)
    eval(['load ' job_pack_0])
end
if ischar(job_pack)
    eval(['load ' job_pack])
end

if ~exist('outdir','var')
    outdir='';
end

peaks=job_pack_0.peaks;
kcand=job_pack_0.kcand;
basic_info=job_pack_0.basic_info;
job_summary.proctim=basic_info.proc;

patches=job_pack.patches;
job=job_pack.job;

hm_job=struct(); % doesn't manage the frequency
hm_job.oper=job_pack_0.basic_info.mode.hm_job.oper;  % oper defined in the mode

sdmin=basic_info.run.sd.min;
dsd=basic_info.run.sd.dnat/job_pack_0.basic_info.mode.hm_job.sdenh;
nsd=round((basic_info.run.sd.max-sdmin)/dsd)+1;
hm_job.sd=[sdmin dsd nsd];

[M dummy]=size(patches);

disp(sprintf(' --- %d maps - %d cands per HM ---',M,kcand))
cand2=[];
ncand=0;
D_duration=0;
E_duration=0;
F_duration=0;
G_duration=0;

for i = 1:M
    patch=patches(i,:);
    [pout,job_info]=hfdf_patch(peaks,basic_info,patch);
    [hfdf,job_info,pout]=hfdf_hough(pout,basic_info,job_info,hm_job); % new hough with pout output
    [cand0,job_info]=hfdf_peak(hfdf,basic_info,job_info,kcand);
    [cand1,job_info]=hfdf_refine_2016(cand0,basic_info,job_info,pout,patch);
%     [cand1,job_info]=hfdf_refine_0(cand0,basic_info,job_info,pout,patch);
    cand2=[cand2 cand1];
    [dummy,nc]=size(cand1);
    ncand=ncand+nc;
    atim=toc(tic0);
    disp(sprintf('%d patch: %f  %f  %d cand  tot %d time:%.2f',i,patch(1),patch(2),nc,ncand,atim))
    D_duration=D_duration+job_info.proc.D_hfdf_patch.duration;
    E_duration=E_duration+job_info.proc.E_hfdf_hough.duration;
    F_duration=F_duration+job_info.proc.F_hfdf_peak.duration;
    G_duration=G_duration+job_info.proc.G_hfdf_refine.duration;
end

% check.D=checkD;
% check.E=checkE;
% check.F=checkF;
% check.G=checkG;

job_summary.vers='140630';
job_summary.jobname=job_pack.job;
job_summary.band=[job_pack_0.basic_info.frin job_pack_0.basic_info.frfi];
job_summary.sd=job_pack_0.basic_info.run.sd;
job_summary.mode=job_pack_0.basic_info.mode;
job_summary.hm_job=hm_job;
job_summary.betas=job_pack.betas;
job_summary.npatches=M;
job_summary.ncand=ncand;
job_summary.parpat=job_pack.parpat;
if isfield(job_info,'error_hough')
    job_summary.error_hough=job_info.error_hough;
end
job_summary.proctim.D_duration=D_duration;
job_summary.proctim.E_duration=E_duration;
job_summary.proctim.F_duration=F_duration;
job_summary.proctim.G_duration=G_duration;
job_summary.proctim.HFDF_JOB.tim=tim0;
job_summary.proctim.HFDF_JOB.duration=ceil(toc(tic0));
job_summary.proctim.HFDF_JOB.end=datestr(now);
if isfield(job_pack_0,'bandjobs')
    job_summary.bandjobs=job_pack_0.bandjobs;
end

jobname=[outdir 'out_' job '.mat'];
cand.cand=cand2;
cand.job_summary=job_summary;
save(jobname,'cand')

jobname=[outdir 'job_summary_' job '.mat'];
save(jobname,'job_summary')