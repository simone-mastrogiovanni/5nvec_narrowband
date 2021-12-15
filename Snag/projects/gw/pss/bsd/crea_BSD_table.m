function BSD_tab=crea_BSD_table(list,tabname,ictab)
% creates a BSD table from a list of files
%
%   list      file list with path (ex.: 'list_O1_L_tfstr.txt')
%   tabname   table name (ex.: 'BSD_O1_L')
%   ictab     =1 table, =0 struct, absent the default (depending on version) 

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

vv=version;
vv=str2double(vv(1:3));
if ~exist('ictab','var')
    ictab=1;
    if vv < 8.2
        ictab=0;
    end
end
ds=dirsep();

fidlist=fopen(list,'r');
nfiles=0;
nofiles=0;

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
    i
    [pathstr,name1,ext] = fileparts(file{i});
    name{i,1}=name1;
    str=[ds,'BSD',ds];
    ii=strfind(pathstr,str);
    path{i,1}=[pathstr(ii:length(pathstr)) ds];
    load(file{i});
    eval(['cont=cont_gd(' name1 ');'])
    eval(['dt=dx_gd(' name1 ');'])
    eval(['n=n_gd(' name1 ');'])
    t_ini(i,1)=cont.t0;
    t_fin(i,1)=adds2mjd(t_ini(i),(n-1)*dt);
    fr_ini(i,1)=cont.inifr;
    fr_fin(i,1)=cont.inifr+cont.bandw;
    run{i,1}=cont.run;
    antenna{i,1}=cont.ant;
    cal{i,1}=cont.cal;   
    eval(['fil=whos(''' name1 ''');'])
    filMbyt(i,1)=fil.bytes/1000000;
    eval(['clear ' name1])
end

if ictab > 0
    BSD_tab=table(name,path,antenna,run,cal,t_ini,t_fin,fr_ini,fr_fin,filMbyt);
else
    BSD_tab=struct('name',name,'path',path,'antenna',antenna,'run',run,'cal',cal);
%         't_ini',t_ini,'t_fin',t_fin,'fr_ini',fr_ini,'fr_fin',fr_fin,'filMbyt',filMbyt);
    ltab=length(t_ini);
    for i = 1:ltab
        BSD_tab(i).t_ini=t_ini(i);
        BSD_tab(i).t_fin=t_fin(i);
        BSD_tab(i).fr_ini=fr_ini(i);
        BSD_tab(i).fr_fin=fr_fin(i);
        BSD_tab(i).filMbyt=filMbyt(i);
    end
end

if exist('tabname','var')
    eval([tabname ' = BSD_tab;'])
    save(tabname,tabname)
end