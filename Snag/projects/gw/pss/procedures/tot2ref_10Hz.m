% tot2ref_10Hz

list='listmat.txt';

fidlist=fopen(list,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});
end

for i = 1:length(file)
    str=file{i}
    eval(['load ' str])
    [pathstr, name, ext] = fileparts(str);
    nameref=[name '_ref'];
    
    eval([nameref '.info=' name '.info;'])
    
    eval(['cand=' name '.cand(1:8,:);'])
    eval(['cand(1:6,:)=' name '.cand(10:15,:);'])
    eval([nameref '.cand=sortrows(cand'');'])
    
    eval(['save(''' nameref ''',''' nameref ''',''-v7.3'')'])
    eval(['clear ' nameref]); 
    eval(['clear ' name]); 
end