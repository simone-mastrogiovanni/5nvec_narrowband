function out=bsd_tfstr_add(list,anabasic)
% adds tf structure to bsds
%
%   list      bsds file list (file should end with sccl)
%   anabasic  basic analysis structure (if absent, default is used)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();

if ~exist('anabasic','var')
    anabasic=struct();
end

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
    [pathstr,name,ext]=fileparts(file{i});
    load(file{i});
    name
    isccl=strfind(name,'sccl');
    name1=[name(1:isccl-1) 'tfstr'];
    eval(['cont=cont_gd(' name ');'])
    eval(['par=bsd_par(' name ');'])
    lfft=par.lfft0;
    eval(['tfstr=bsd_peakmap(' name ',lfft);']);
    tfstr.bsd_par=par;
    if tfstr.pt.ntotpeaks <= 0
        tfstr.pt.ERROR=1;
        disp(' *** ERROR in PEAK TABLE')
    else
        tfstr=bsd_tfclean(tfstr,anabasic);
    end
    eval(['[zhole, shole]=bsd_holes(' name ');']);
    tfstr.zeros=shole;
    cont.tfstr=tfstr;
    eval([name1 '=edit_gd(' name ',''cont'',cont)'])
    eval(['clear ' name])
    eval(['save(''' name1 ''',''' name1 ''',''-v7.3'')'])
    eval(['clear ' name1])
%     save(file{i});
end