function [tab, tabpar]=read_tab_bsd(addr,ant,runame)
%
%  typical call [tab tabpar]=read_tab_bsd('I:','ligol','O2')

switch ant
    case 'virgo'
        ach='V';
    case 'ligol'
        ach='L';
    case 'ligoh'
        ach='H';
end

tab_name=['BSD_tab_' runame '_' ach];

load([addr dirsep 'BSD' dirsep tab_name]);
eval(['tab=' tab_name ';'])

t_ini=tab.t_ini;
t_fin=tab.t_fin;
fr_ini=tab.fr_ini;
fr_fin=tab.fr_fin;
filMbyt=tab.filMbyt;

tabpar.t_ini=min(t_ini);
tabpar.t_fin=max(t_fin);
tabpar.fr_ini=min(fr_ini);
tabpar.fr_fin=max(fr_fin);
tabpar.Gbyte=sum(filMbyt)/1000;