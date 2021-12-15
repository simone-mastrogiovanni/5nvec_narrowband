function [cand,job_info,checkF]=hfdf_peak_1(hfdf,basic_info,job_info)
% finds peaks in the hough map FOR SINGLE CANDIDATE
%
%   [cand,job_info,checkF]=hfdf_peak(hfdf,basic_info,job_info,kcand)
%
%    hfdf        hough map
%    basic_info
%    job_info
%    kcand       number of primary candidates to be found
%
%    cand(9,N)   [fr lam bet sd amp CR dlam dbet typ]
%    job_info    job info structure
%    checkF      service structure for test and debug

% Version 2.0 - November 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

tic
checkF=struct();
job_info.proc.F_hfdf_peak.vers='140630';
job_info.proc.F_hfdf_peak.kcand=1;
job_info.proc.F_hfdf_peak.tim=datestr(now);

mode=basic_info.mode.peak_mode;
job_info.proc.F_hfdf_peak.mode=mode;
if mode == 2
    mno=basic_info.mode.hm_job.frenh*4;
    job_info.proc.F_hfdf_peak.mno=mno;
end
frini=basic_info.frin;
frfin=basic_info.frfi;

g=cut_gd2(hfdf,[frini,frfin],[-100,100],1);
y=y_gd2(g);

robst=robstat(y(:),0.01);
robmed=robst(1);
robstd=robst(2);

if isfield(job_info,'frlim')
    frini=job_info.frlim(1);
    frfin=job_info.frlim(2);
end
cand=zeros(9,1);

g=cut_gd2(hfdf,[frini,frfin],[-100,100],1);
y=y_gd2(g);

job_info.robmed=robmed;
job_info.robstd=robstd;

[ma,fr,sd]=maxmax(g);

cand(1,1)=fr;
cand(2,1)=job_info.patch(1);
cand(3,1)=job_info.patch(2);
cand(4,1)=sd;
cand(5,1)=ma;
cand(6,1)=(ma-robmed)/robstd;
% cand(7,1)=job_info.patch(3)/2;
% cand(8,1)=(job_info.patch(4)-job_info.patch(5))/4;
cand(9,1)=1;

job_info.ncand=1;
job_info.proc.F_hfdf_peak.duration=toc;
