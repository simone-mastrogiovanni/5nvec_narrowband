% conc_vbl
% all output files in the same folder

% filelist='list_VSR2_pmcl.txt'; % EDIT
% filelist='list_VSR2_1024_pmcl.txt'; % EDIT
filelist='list_O1L_2048Hz_pm_cl.txt'; % EDIT
foldout='out\';

fidlist=fopen(filelist,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    filt=fgetl(fidlist);
%     filein{nfiles}=filt;
    [pathstr, name, ext]=fileparts(filt);
    fil=[name ext];
    files{nfiles}=fil;
    copyfile(filt,[foldout fil]);
end

N=length(files)

for i = 1:N
    fid=fopen([foldout files{i}],'r+'); files{i}
    if i < N
        filspost=files{i+1};
        filppost='';
    else
        filspost='#NOFILE';
        filppost='#NOFILE';
    end
    if i > 1
        filspre=files{i-1};
        filppre='';
    else
        filspre='#NOFILE';
        filppre='#NOFILE';
    end
    fseek(fid,432,'bof');
    fprintf(fid,'%128s',filspre);
    fprintf(fid,'%128s',filspost);
    fprintf(fid,'%128s',filppre);
    fprintf(fid,'%128s',filppost);
end

fclose('all')