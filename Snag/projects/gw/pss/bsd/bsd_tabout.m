function BSD_tab_out=bsd_tabout(addr,ant,runame,tim,freq)
% sub-table as in bsd_lego
%
%     BSD_tab_out=bsd_tabout(addr,ant,runame,tim,freq)
%
%    addr      path that contains BSD data master directory without the final dirsep
%                or structure with all the input parameters as fields
%    ant       antenna name
%    runame    run name 
%    tim       [tini tfin] (mjd) ; if length(tim) = 1 or tini=tfin the whole run
%              [tini tfin dt0] if the sampling time dt0 of the BSD collection is not 0.1 s
%    freq      [frini frfin] ; if length(freq) = 1 or frini=frfin the full band with frini (def ortho-band)
%               (freq is the requested band, band will contain the effective band)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(tim) == 3
    dt0=tim(3);
else
    dt0=0.1;
end

if length(tim) > 1
    if tim(1) == tim(2)
        tim=1;
    end
end

if length(freq) > 1
    if freq(1) == freq(2)
        freq=freq(1);
    end
end

bsd_out=0;
icmodif=0;

if exist('modif','var')
    icmodif=1;
else 
    modif=[];
end

if ~exist('mode','var')
    mode=1;
end

switch ant
    case 'virgo'
        ach='V';
    case 'ligol'
        ach='L';
    case 'ligoh'
        ach='H';
end

switch runame
    case 'O1'
        t_ini_run=57277;
        t_fin_run=57369;
    case 'O2'
        t_ini_run=57757;
        t_fin_run=57991;
    case 'O3'
end

ictim=1;

tab_name=['BSD_tab_' runame '_' ach];

load([addr dirsep 'BSD' dirsep tab_name]);
eval(['tab=' tab_name ';'])

[BSD_tab_out,stpar]=bsd_subtab(tab,tim,freq,dt0);stpar