function out=bsd_tfstr_addwithnotch(list,parnotch,anabasic)
% adds tf structure to bsds performing notch filtering
%
%   list            bsds file list (file should end with sccl)
%   parnotch        notch parameters (if absent or a void structure or not a structure, default values)
%           .thr      threshold on persistence
%           .win      window (def 1)
%           .linel    line list [n,2] (frmin frmax)
%   anabasic        basic analysis structure (if absent, default is used)

% Version 2.0 -November 2018
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
    cont.tfstr=tfstr;
    eval([name1 '=edit_gd(' name ',''cont'',cont)'])
    
    eval([name1 '=bsd_notch(' name1 ',parnotch);'])
    
    eval(['clear ' name])
%     eval([name '=gdadv(' name ');'])
%     eval([name '=edit_gdadv(' name ',''tfstr'',tfstr)'])
    eval(['save(''' name1 ''',''' name1 ''',''-v7.3'')'])
    eval(['clear ' name1])
%     save(file{i});
end