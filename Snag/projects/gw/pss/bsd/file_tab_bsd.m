function files=file_tab_bsd(addr,tab)
% adds path and extention to bsds from a table
%
%    files=file_tab_bsd(addr,tab)
%
%    addr    BSD path (without final dirsep)
%    tab     bsd table

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isstruct(tab)
    n=length(tab);

    files=cell(n,1);

    for i = 1:n
        name=tab(i).name;
        path=tab(i).path;
        files{i}=[addr path name '.mat'];
    end
else
    name=tab.name;
    path=tab.path;
    n=length(path);

    files=cell(n,1);

    for i = 1:n
        files{i}=[addr path{i} name{i} '.mat'];
    end
end