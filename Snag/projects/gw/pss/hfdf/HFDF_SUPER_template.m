% HFDF_SUPER_template

% data_list='G:\Virgo\VSR2\pm\256Hz-hp20\clear\list.txt';
% runstr=VSR2(1);
data_list='G:\Virgo\VSR4\pm\256Hz-hp20\clear\list.txt';
runstr=VSR4(1);
mode=hfdf_mode;
anaband=runstr.anaband; %anaband=[20 22 1];
register='job_prep_register.txt';

fid=fopen(register,'w');
% anaband(1)=111

% for frmin = anaband(1):anaband(3):anaband(2)
for frmin = 84:anaband(3):anaband(2)
    [job_pack_0, job_packs]=HFDF_PREPJOB(data_list,frmin,runstr,mode);
    n=length(job_packs);
    fprintf(fid,'%s  %d jobs\n',job_pack_0.job_0,n);
    for j = 1:n
        fprintf(fid,'%s\n',job_packs{j}.job);
    end
%     pause(1)
end

fclose(fid);