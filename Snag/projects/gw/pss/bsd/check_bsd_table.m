function out=check_bsd_table(tab)
% checks a bsd table (or structure table)

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

vv1=version;
vv=str2double(vv1(1:3));
if ~exist('ictab','var')
    ictab=1;
    if vv < 8.2
        ictab=0;
        fprintf(' Old Matlab version (%s) : structures instead of tables will be used \n',vv1)
    end
end

single_t=0;
single_fr=0;

switch ictab
    case 1
        t_ini=tab.t_ini;
        t_fin=tab.t_fin;
        fr_ini=tab.fr_ini;
        fr_fin=tab.fr_fin;
        filMbyt=tab.filMbyt;
    case 0
        ltab=length(tab);
        for i = 1:ltab
            t_ini(i)=tab(i).t_ini;
            t_fin(i)=tab(i).t_fin;
            fr_ini(i)=tab(i).fr_ini;
            fr_fin(i)=tab(i).fr_fin;
            filMbyt(i)=tab(i).filMbyt;
        end
end

tin=min(t_ini);
tfi=max(t_fin);

frin=min(fr_ini);
frfi=max(fr_fin);

[C,ia,kt] = unique(t_ini);
n_t=length(ia);

if length(C) == 1
    single_t=1;
end

[C,ia,kfr] = unique(fr_ini);
n_f=length(ia);

if length(C) == 1
    single_fr=1;
end

out.single_t=single_t;
out.single_fr=single_fr;
out.n_t=n_t;
out.n_f=n_f;
out.kt=kt;
out.kfr=kfr;

out.N=length(t_ini);
out.trange=[tin tfi];
out.frange=[frin frfi];
out.band0=frfi-frin;
out.n=(tfi-tin)*86400*(frfi-frin);
out.Mbyt=sum(filMbyt);