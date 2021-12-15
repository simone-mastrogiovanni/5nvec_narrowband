function [tab_out,epoch0,maxt]=bsd_extr_subtab(tab,tim,fr)
% extracts a sub table from a bsd table
%
%  tab    input table
%  tim    any time in the file (0 no choice)
%  fr     any frequency in the file (0 no choice)

% Snag Version 2.0 - May 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isstruct(tab)
    [N,dummy]=size(tab);
    t_ini=zeros(1,N);
    t_fin=t_ini;
    fr_ini=t_ini;
    fr_fin=t_ini;
    for i=1:N
        t_ini(i)=tab(i).t_ini;
        t_fin(i)=tab(i).t_fin;
        fr_ini(i)=tab(i).fr_ini;
        fr_fin(i)=tab(i).fr_fin;
    end
else
    t_ini=tab.t_ini;
    t_fin=tab.t_fin;
    fr_ini=tab.fr_ini;
    fr_fin=tab.fr_fin;
end

epoch0=(max(t_fin)+min(t_ini))/2;
maxt=86400*(max(t_fin)-min(t_ini))/2;

if tim > 0 
    it=find(t_ini <= tim & t_fin > tim);
else
    it=1:length(t_ini);
end

if fr > 0
    ifr=find(fr_ini(it) <= fr & fr_fin(it) > fr);
else
    ifr=1:length(it);
end

ii=it(ifr);

tab_out=bsd_seltab(tab,ii);

