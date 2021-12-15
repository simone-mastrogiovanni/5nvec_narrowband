function out=hfdf_mode(typ)
% model of mode function

if ~exist('typ','var')
    typ=1;
end
  
% crea_peak_table
out.pers_par=[1 1]; % persistence veto parameters
out.veto_lines=[];  % persistence vetoed lines (output data)

% clean_peak_table
out.veto_sour={};
% out.veto_sour{1}=pulsar_3;

% hfdf_hough
out.hm_job.oper='adapt';
out.hm_job.frenh=10; % frequency enhancement factor
out.hm_job.sdenh=1;  % spin-down enhancement factor

% peak_mode  1 simple, 2 redo
out.peak_mode=2;

% hfdf_refine
out.ref.skylayers=2;
% out.ref.sd.enh=5;
% out.ref.sd.min=-8;
% out.ref.sd.max=8;
out.ref.sd.enh=6;
out.ref.sd.min=-12;
out.ref.sd.max=11;

switch typ
    case 2
        out.hm_job.sdenh=1;  % hough spin-down enhancement factor
        
        out.ref.sd.enh=6;
        out.ref.sd.min=-6;
        out.ref.sd.max=5;
    case 3
        out.hm_job.sdenh=1;  % hough spin-down enhancement factor
        
        out.ref.sd.enh=6;
        out.ref.sd.min=-9;
        out.ref.sd.max=9;
    case 23
        out.hm_job.sdenh=1;  % hough spin-down enhancement factor
        
        out.ref.sd.enh=2;
        out.ref.sd.min=-4;
        out.ref.sd.max=3;
end