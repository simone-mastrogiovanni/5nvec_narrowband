function [candout,job_info,checkG]=bsd_refine(candin,proc_info,job_info,peaks,patch)
% refines the candidates (wrapper for bsd_hspot)
%
%   [candout,job_info,checkG]=bsdf_refine(candin,basic_info,job_info,peaks,patch)
%
%   candin      raw candidates (9,M)
%   proc_info   bprocedure info structure
%   job_info    job info structure
%   peaks       peaks corrected for the patch
%   patch       patch used to compute the candidates
%
%   candout     refined candidates (15,M)
%   job_info    job info structure
%   checkG      service structure for test and debug
%
%  candout rows:
%
%         1	frequency (raw)
%         2	lambda (raw)
%         3	beta (raw)
%         4	spin-down (raw)
%         5	amplitude (raw)
%         6	CR (raw)
%         7	dlam
%         8	dbet
%         9	type
%         10	frequency (ref)
%         11	lambda (ref)
%         12	beta (ref)
%         13	spin-down (ref)
%         14	amplitude (ref)
%         15	CR (ref)

% Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.Piccinni, S.DÁntonio, S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ttoc=tic;
disp('DEFINIRE proc_info.t0 !!!')

job_info.proc.G_bsd_refine.vers='170230';
job_info.proc.G_bsd_refine.tim=datestr(now);

[candout,job_info,checkG]=bsd_hspot(2,candin,proc_info,job_info,peaks,patch);
 
job_info.proc.G_bsd_refine.refpar=job_info.proc.G_bsd_hspot.refpar;
job_info.proc.G_bsd_refine.DF=job_info.proc.G_bsd_hspot.DF;
job_info.proc.G_bsd_refine.nDF=job_info.proc.G_bsd_hspot.nDF;
job_info.proc.G_bsd_refine.nSD=job_info.proc.G_bsd_hspot.nSD;
job_info.proc.G_bsd_refine.nFenhSD=job_info.proc.G_bsd_hspot.nFenhSD;

job_info.proc.G_bsd_refine.duration=toc(ttoc);
