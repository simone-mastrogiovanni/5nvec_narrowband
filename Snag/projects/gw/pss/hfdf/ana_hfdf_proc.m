function out=ana_hfdf_proc(struc)
% analysis of hfdf procedures
%
%  struc   input structure or name of the container mat file
%          possible types:
%            1 job_pack_0
%            2 job_pack
%            3 basic_info
%            4 job_info
%            5 job_summary

% Version 2.0 - November 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

out=struct();

if ischar(struc)
    a=load(struc);
    fiel=fieldnames(a);
    fiel=fiel{1};
    eval(['struc=a.' fiel ';']);
end

if isfield(struc,'basic_info')
    ic=1;
    disp('The structure is a job_pack_0')
elseif isfield(struc,'job')
    ic=2;
    disp('The structure is a job_pack')
elseif isfield(struc,'run')
    ic=3;
    disp('The structure is a basic_info')
elseif isfield(struc,'patch')
    ic=4;
    disp('The structure is a job_info')
elseif isfield(struc,'proctim')
    ic=5;
    disp('The structure is a job_summary')
end

switch ic
    case 1
        show_proc(struc.basic_info.proc);
    case 2
        fprintf('job %s\n',struc.job);
        figure,plot(struc.patches(:,1),struc.patches(:,2),'.');
        grid on,title('patches'),xlabel('\lambda'),ylabel('\beta')
    case 3
        show_proc(struc.proc);
        fprintf('run %s \n',struc.run.run)
    case 4
        show_proc(struc.proc);
    case 5
        fprintf('HFDF_JOB  %s\n',struc.jobname);
        fprintf('  started at %s for %s\n',struc.proctim.HFDF_JOB.tim,s2dhms(struc.proctim.HFDF_JOB.duration));
        fprintf('    %d patches   %d betas   %d candidates \n',struc.npatches,length(unique(struc.betas)),struc.ncand)
        show_proc(struc.proctim);
        fprintf('D_duration %s\n',s2dhms(struc.proctim.D_duration))
        fprintf('E_duration %s\n',s2dhms(struc.proctim.E_duration))
        fprintf('F_duration %s\n',s2dhms(struc.proctim.F_duration))
        fprintf('G_duration %s\n',s2dhms(struc.proctim.G_duration))
end


function show_proc(proc)

if isfield(proc,'A_read_peakmap')
    fprintf('A_read_peakmap    started at %s for %.2f s  band %d-%d Hz\n',...
        proc.A_read_peakmap.tim,proc.A_read_peakmap.duration,proc.A_read_peakmap.frband);
    fprintf('  on list %s \n',proc.A_read_peakmap.list)
end
if isfield(proc,'B_crea_peak_table')
    fprintf('B_crea_peak_table started at %s for %.2f s\n',proc.B_crea_peak_table.tim,proc.B_crea_peak_table.duration);
end
if isfield(proc,'C_clear_peak_table')
    fprintf('C_clear_peak_table started at %s for %.2f s\n',proc.C_clear_peak_table.tim,proc.C_clear_peak_table.duration);
end
if isfield(proc,'D_hfdf_patch')
    fprintf('D_hfdf_patch started at %s for %.2f s \n  patch %.3f %.3f %.3f %.3f %.3f \n',...
        proc.D_hfdf_patch.tim,proc.D_hfdf_patch.duration,proc.D_hfdf_patch.patch);
end
if isfield(proc,'E_hfdf_hough')
    fprintf('E_hfdf_hough started at %s for %.2f s  Hough type: %s\n',...
        proc.E_hfdf_hough.tim,proc.E_hfdf_hough.duration,proc.E_hfdf_hough.hm_job.oper);
end
if isfield(proc,'F_hfdf_peak')
    fprintf('F_hfdf_peak started at %s for %.2f s\n',proc.F_hfdf_peak.tim,proc.F_hfdf_peak.duration);
end
if isfield(proc,'G_hfdf_refine')
    fprintf('G_hfdf_refine started at %s for %.2f s\n skylayers %d  sd enh,min,max %d %d %d\n',...
        proc.G_hfdf_refine.tim,proc.G_hfdf_refine.duration,proc.G_hfdf_refine.refpar.skylayers,...
        proc.G_hfdf_refine.refpar.sd.enh,proc.G_hfdf_refine.refpar.sd.min,proc.G_hfdf_refine.refpar.sd.max);
end