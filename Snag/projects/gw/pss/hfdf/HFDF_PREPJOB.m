function [job_pack_0, job_packs]=HFDF_PREPJOB(list,frmin,runstr,mode)
% job preparation: creates the basic peak table
%
%   [peaks,basic_info,sky,check]=HFDF_PREPJOB(list,frmin,runstr,mode)
%
%   list        vbl files list
%   frmin       min frequency (>= anaband(1)); 
%   runstr      run structure
%   mode        modification of the runstr def (proc mode)
%
%   peaks       basic peak table
%   basic_info  basic info structure
%   sky         sky structure
%   check       check structure

% Version 2.0 - November 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

tic0=tic;
tim0=datestr(now);

frband=[frmin frmin+runstr.anaband(3)];

if frmin < runstr.anaband(1)
    disp('   frmin < runstr.anaband(1) !!!')
    frmin,runstr.anaband(1)
    exit
end

a=runstr.sd.min/runstr.sd.dnat;
a=a-round(a);
if abs(a) > 0.01
    fprintf(' *** sd error: the step must be a sub-multiple of min\n')
    return
end

% [A,basic_info,checkA]=read_peakmap(list,frband,0,0,runstr);
[A,basic_info,checkA]=read_peakmap_2016(list,frband,0,runstr);

if exist('mode','var')
    basic_info.mode=mode;
else
    basic_info.mode=struct();
end

[peaks,basic_info,checkB]=crea_peak_table(A,basic_info);

[peaks,basic_info,checkC]=clean_peak_table(peaks,basic_info);

outcomp=hfdf_compute(runstr,[100000000 1 0]);
% kk=frmin-outcomp.fr(1)+1; ERRORE
kk=round((frmin-outcomp.fr(1))/runstr.anaband(3))+1;
kcand=outcomp.kcand(kk);
basic_info.comp=outcomp;
ii=round((frband(1)-runstr.anaband(1)+runstr.anaband(3))/runstr.anaband(3));  % OK !!!
ndop=outcomp.Ndoppler(ii);
[x,b,index,nlon]=pss_optmap(ndop,1);
sky.Ndoppler=ndop;
sky.x=x;
sky.beta=b;
sky.index=index;
sky.nlong=nlon;
nbeta=length(b);
totpoint=sum(nlon);

job_0=sprintf('%s_%04d_',runstr.run,frmin);
job_pack_0=struct();
job_pack_0.sky=sky;
job_pack_0.kcand=kcand;
job_pack_0.job_0=job_0;
job_pack_0.peaks=peaks;
jobname_0=['in_' job_0];
jobname_s=['jobs_' job_0];
disp(sprintf('job_0: %s totpoint = %d',jobname_0,totpoint))

nskymin=1000;
n1=1;
i=0;
n2=0;
jj=0;

while n2 < totpoint
    jj=jj+1;
    n=0;
    while n < nskymin & i < nbeta
        i=i+1;
        n=n+nlon(i);
    end
    n2=n2+n;
    if n2 >= totpoint
        n2=totpoint;
    end
    patches=x(n1:n2,:);
    job=sprintf('%s_%04d_%03d_%07.3f_%07.3f_',runstr.run,frmin,jj,x(n1,2),x(n2,2));
    disp(sprintf('job %d  %s %d %d  npoint = %d',jj,job,n1,n2,n2-n1+1))
    job_pack=struct();
    job_pack.number=jj;
    job_pack.job=job;
    job_pack.patches=patches;
    [job_pack.betas,iun]=unique(x(n1:n2,2));
    job_pack.parpat=patches(iun,2:5);
    jobname=['in_' job '.mat'];
    save(jobname,'job_pack')
    job_packs{jj}=job_pack;
    pause(0.1)
    n1=n2+1;
end

job_pack_0.bandjobs=jj;

check.A=checkA;
check.B=checkB;
% check.C=checkC;

basic_info.proc.HFDF_PREPJOB.vers='140630';
basic_info.proc.HFDF_PREPJOB.tim=tim0;
basic_info.proc.HFDF_PREPJOB.duration=toc(tic0);
job_pack_0.basic_info=basic_info;
save(jobname_0,'job_pack_0')
save(jobname_s,'job_packs')