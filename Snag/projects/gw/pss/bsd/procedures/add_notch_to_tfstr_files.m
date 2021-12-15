% add_notch_to_tfstr_files
%
% work in a different folder than the source files

list='list_O2_L_tfstr.txt';
list='list_O2_H.txt'

lines=ligo_readlines('O2L1lines.csv');
lines=ligo_readlines('O2H1lines.csv');

parnotch.linel=lines;
parnotch.thr=0.2;
parnotch.win=1;

fidlist=fopen(list,'r');
nfiles=0;
nofiles=0;

tic

while (feof(fidlist) ~= 1)
    str=fgetl(fidlist);
    str1=str(1);
    if strcmp(str1,'*')
        nofiles=nofiles+1;
        fprintf('  %s  NOT CONSIDERED \n',str);
        continue
    else
        nfiles=nfiles+1;
        file{nfiles}=str;
        fprintf('  %s \n',str);
    end
end
nfiles,nofiles

for i = 1:nfiles
% for i = 1:2
    [pathstr,name,ext]=fileparts(file{i});
    load(file{i});
    name
    eval([name '=bsd_notch(' name ',parnotch);'])

    eval(['save(''' name ''',''' name ''',''-v7.3'')'])
    eval(['clear ' name])
end

toc