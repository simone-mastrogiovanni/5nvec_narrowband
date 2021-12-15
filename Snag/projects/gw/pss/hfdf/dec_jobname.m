function out=dec_jobname(jobname,bias)

if ~exist('bias','var')
    bias=0;
end
jobname=jobname(bias+1:length(jobname));

vrun=jobname(1:4);
% setpp=str2num(jobname(6:7));
eval(['out.run=' vrun '(' jobname(6:7) ');']);

out.frin=str2num(jobname(9:12));
out.kjob=str2num(jobname(14:16));
out.bet1=str2num(jobname(18:24));
out.bet2=str2num(jobname(26:32));