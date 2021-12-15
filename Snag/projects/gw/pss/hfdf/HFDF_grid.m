function [ret] = HFDF_grid(indir, run_freq, sky_band, outdir)
% after HFDF_PREPJOB, launches HFDF_JOB 
%
%    [ret] = HFDF_grid(indir, run_freq, sky_band, outdir)
%
%    indir      input directory
%    run_freq   header (ex.: VSR4_01_0020)
%    sky_band   string as 004_042.694_034.647
%    outdir     output directory 

% Version 2.0 - December 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Alberto Colla - alberto.colla@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

job_pack_0 = [indir '/in_' run_freq '_.mat'];
job_pack = [indir '/in_' run_freq '_' sky_band '_.mat'];
%outdir=pwd;

if ~exist(job_pack_0) 
    disp(sprintf('Error: File %s not found!\n', job_pack_0));
    exit(-1)
end
if ~exist(job_pack) 
    disp(sprintf('Error: File %s not found!\n', job_pack));
    exit(-1)
end 


% [cand,job_summary,check]=HFDF_JOB('in_VSR2_01_0022_.mat','in_VSR2_01_0022_003_-54.977_-90.000_.mat');

[cand,job_summary,check]=HFDF_JOB(job_pack_0, job_pack, outdir);


if exist ('cand')
    display('Job finished successfully: candidates found!');
    ret=0;
else
    display('Job failed: candidates not found!');
    ret=1;
end

% [cand,job_summary,check]=HFDF_JOB('in_VSR2_01_0064_.mat','in_VSR2_01_0064_003_060.444_054.251_.mat');

%[cand,job_summary,check]=HFDF_JOB('in_VSR2_01_0108_.mat','in_VSR2_01_0108_029_-28.336_-30.852_.mat');
