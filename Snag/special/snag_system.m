function [prog,status,cmdout]=snag_system(coms,sep)
% to manage system commands
%
%   [status,cmdout]=snag_system(coms,sep)
%
%   coms     commands (a cell array or file name)
%   sep      var separator (default #)
%  
%   prog     interpreted program
%   status   status array
%   cmdout   command output cell array
%
%   The coms begins with the variables definition, example:
%
%   #beginvar
%   #fold1#='D:\prova\sub\'
%   #num1#=30
%   #endvar
%
%   Then the real program starts; it is in Matlab, but variables are
%   substituted by their values and lines starting with ! are interpreted
%   as system commands

% Version 2.0 - January 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

status={};
cmdout={};

if ischar(coms)
    fid=fopen(coms);
%     tline=' ';
    i=0;
    while ~feof(fid)
        i=i+1;
        tline=fgetl(fid);
        disp(tline)
        v{i}=tline;
    end
    coms=v;
end

if ~exist('sep','var')
    sep='#';
end

nc=length(coms);
stat=2;
iv=0;
prog=[];

for i = 1:nc
    str=coms{i};i,str
    if stat == 1
        [s1,s2]=strtok(str,'=');
        if ~isempty(s2)
            iv=iv+1;
            var{iv}=s1;
            s2=s2(2:length(s2));
            if s2(1) == ''''
                s2=['''' s2 ''''];
            end
            varval{iv}=s2;
        end
    else
        if str(1) == '!'
            com1=str(2:length(str));
            kk=strfind(com1,sep);
            com=[];
            j1=1;
            for j = 1:2:length(kk)
                com=[com com1(j1:kk(j)-1)];
                v=com1(j:j+1);
                for k = 1:iv
                    if strcmp(var{k},v)
                        com=[com varval{k}];
                    end
                end
                j1=kk(j+1)+1;
            end
            com=['system(''' com ''')']; 
            eval(com)
        else
            com=str;
        end
        prog=[prog com];
    end
    if length(str) > 8 && strcmp(str(1:9),'#beginvar')
        stat=1;
    end
    if length(str) > 6 && strcmp(str(1:7),'#endvar')
        stat=2;
    end
end
