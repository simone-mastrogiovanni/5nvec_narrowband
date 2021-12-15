function sfdb09_band2sbl3_grid(fstart,fstop,sfdb_list,sbl_dir,sbl_name,out_type,freqfile)

fstart=str2num(fstart);
fstop=str2num(fstop);

if ~exist('freqfile','var')
    freq_band=[fstart,fstop];
    if (fstart >= 100 && fstart < 1000)
        f0=['0' num2str(fstart)];
    elseif fstart < 100
        f0=['00' num2str(fstart)];
    else
        f0=num2str(fstart);
    end
    if (fstop >= 100 && fstop < 1000)
        f1=['0' num2str(fstop)];
    elseif fstop < 100
        f1=['00' num2str(fstop)];
    else
        f1=num2str(fstop);
    end
    sbl_name=[sbl_name '_' f0 '_' f1 '.sbl']
    sfdb09_band2sbl3(freq_band,2,'',sfdb_list,sbl_name);
else
    fid=fopen(freqfile,'r');
    i=1;
    while ~feof(fid)
        A=fscanf(fid,'%f %f\n',2);
        if ~isempty(A)
            freq_band{i}=A;
            i=i+1;
        end
    end
    fclose(fid);
    sfdb09_band2sbl3_parallel(freq_band,2,'',sfdb_list,sbl_name);
end
counter = 0;
status = 1;
if strcmp(out_type,'grid')
    while (status == 1 && counter < 3)
        command=['lcg-cr -v -b --vo virgo -l /grid/virgo/' sbl_dir '/' sbl_name ' -T srmv2 -d srm://storm-fe-archive.cr.cnaf.infn.it:8444/srm/managerv2?SFN=/virgo4/virgo/' sbl_dir '/' sbl_name ' file://$(pwd)/' sbl_name];
        %command=['lcg-cr -v --vo virgo -d storm-fe-archive.cr.cnaf.infn.it -l /grid/virgo/' sbl_dir '/' sbl_name ' file://$(pwd)/' sbl_name];
        [status, result] = system(command)
        if status == 1
            counter=counter+1;
        end
    end
elseif strcmp(out_type,'local')
    command=['cp ' sbl_name '' sbl_dir];
    [status, result] = system(command);
end

%If you want just to specify the final storage, but not the physical
%location of output files, use: command=['lcg-cr -v --vo virgo -d
%storm-fe-archive.cr.cnaf.infn.it -l lfn:/grid/virgo/' sbl_dir '/' sbl_name ' file://$(pwd)/' sbl_name];
