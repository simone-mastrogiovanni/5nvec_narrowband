function [bsd, name]=load_tab_bsd(addr,tab,k,modif)
% loads a bsd from a table
%
%    [bsd, name]=load_tab_bsd(addr,tab,k)
%
%    addr    BSD path (without final dirsep)
%    tab     bsd table
%    k       file index
%    modif   modification structure

% Snag Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isstruct(tab)
    name=tab(k).name;
    path=tab(k).path;
else
    name=tab.name{k};
    path=tab.path{k};
end

path=cpath(path);

str=['load(''' addr path name ''')'];
eval(str)

eval(['bsd=' name ';'])

if exist('modif','var')
    bsd=bsd_acc_modif(bsd,modif);
end