function [subtab,par]=bsd_subtab(tab,tim,freq,dt0)
% extract a bsd sub-table
%
%    tab       BSD table
%    tim       [tini tfin] (mjd) ; if length(tim) = 1 the whole run
%    freq      [frini frfin] ; if length(freq) = 1 the full band with frini

% Snag Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if exist('dt0','var')
    icdt0=1;
else
    icdt0=0;
end

name=tab.name;
path=tab.path;
antenna=tab.antenna;
run=tab.run;
cal=tab.cal;
t_ini=tab.t_ini;
t_fin=tab.t_fin;
fr_ini=tab.fr_ini;
fr_fin=tab.fr_fin;
filMbyt=tab.filMbyt;

if length(tim) == 2  
    par.tchoice=1;
    it=find(t_ini < tim(2) & t_fin > tim(1));
else
    par.tchoice=0;
    it=1:length(t_ini);
end

if length(freq) >= 2
    par.fchoice=1;
    ifr=find(fr_ini(it) < freq(2) & fr_fin(it) > freq(1));
else
    par.fchoice=0;
    ifr=find(fr_ini(it) <= freq(1) & fr_fin(it) > freq(1));
end

ii=it(ifr);

subtab=bsd_seltab(tab,ii);

t_ini=subtab.t_ini;
t_fin=subtab.t_fin;
fr_ini=subtab.fr_ini;
fr_fin=subtab.fr_fin;

par.tim=tim;
par.freq=freq;
par.Dt=max(t_fin-t_ini);
par.DT=max(t_fin)-min(t_ini);
par.Df=max(fr_fin-fr_ini);
par.DF=max(fr_fin)-min(fr_ini);
par.F0=min(fr_ini);

single_t=0;
single_f=0;

[C,ia,kt] = unique(t_ini);
n_t=length(ia);

if length(C) == 1
    single_t=1;
end

[C,ia,kfr] = unique(fr_ini);
n_f=length(ia);

if length(C) == 1
    single_f=1;
end

par.n_t=n_t;
par.single_t=single_t;
par.n_f=n_f;
par.single_f=single_f;

par.N=length(t_ini);
par.trange=[t_ini t_fin];
par.frange=[fr_ini fr_fin];
par.bandw0=fr_fin(1)-fr_ini(1);

par.Tmax=max(t_fin-t_ini)*86400;

if n_f > 2
    par.largeband=max(fr_fin)-min(fr_ini);
    par.largerband=max(fr_fin);
    par.fchoice=n_f;
end

if icdt0
    if par.fchoice == 1
        par.Nfft0=round(par.Tmax/dt0)+1;
        par.lens=round((t_fin-t_ini)*86400/dt0)+1;
        par.dfr=1/(par.Nfft0*dt0);
        par.if1=round((freq(1)-par.F0)/par.dfr)+1;
        par.if2=round((freq(2)-par.F0)/par.dfr)+1;
        par.dif=par.if2-par.if1+1;
        par.band0=[par.if1 par.if2]*par.dfr;
        par.band=par.band0+par.F0;
        par.bandw=par.band(2)-par.band(1);
        par.dt=1/par.bandw;
    end
end