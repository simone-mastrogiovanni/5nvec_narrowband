function total_clean_from_gd_list(list_gd,sciseglist)
% total_clean_gd: function to select data science segments (read from a file be careful with the format of the file),put a
% threshold on data and add zeros at the beginning of the gd in order to
% let the gds start from h 0 of the first day
% list gd   list of gds to be cleaned
% sciseglist  science segment list (different format of files pay attention) (e.g. '/storage/users/piccinni/O1_H1_segments_science_full.txt')
%O.J.Piccinni july 2016

fidlist=fopen(list_gd); %the list of files must contain the entire filepath
tline=fgetl(fidlist); 
nfil=0;

while tline ~= -1
    nfil=nfil+1;
    file{nfil}=tline;
    tline=fgetl(fidlist);
end



for i = 1:nfil                                  %for each file
    tic
    whos
    in_name=file{i};
    disp(in_name)
    load(in_name);
    [~,gd_iname,ext] = fileparts(in_name);
    gd_outname=strcat([gd_iname(1:end-3),'_sccl'])

    str1=strcat([gd_outname '=total_clean_gd(',gd_iname, ',''',sciseglist ,''');'])
    eval(str1)
    eval(['save ' gd_outname ' ' gd_outname ])
    clear in_name ext str1
    eval(['clear ' gd_outname ' ' gd_iname ])
    toc
end
