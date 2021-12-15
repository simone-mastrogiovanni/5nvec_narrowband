function [bsd_out,BSD_tab_out,out]=bsd_access(addr,ant,runame,tim,freq,mode,modif,modifpost)
% data access
%
%     [bsd_out,BSD_tab_out,out]==bsd_access(addr,ant,run,tim,freq,mode,modif,modifpost)
%
%    addr      path that contains BSD data master directory without the final dirsep
%    ant       antenna name
%    runame    run name 
%    tim       [tini tfin] (mjd) ; if length(tim) = 1 the whole run
%    freq      [frini frfin] ; if length(freq) = 1 the full band with frini
%    mode      mode  = 0 only the output table
%                    > 0 creates the output bsd
%                    = 1 automatic
%                    = 2 sub-band of concatenated files 
%                    = 20 sub-band, concatenates files (raw way) (ATTENTION ! may give wrong results; use 2)
%                    = 21 sub-ortho-band
%                    = 3 sub-period, many bands
%                    = 4 inter-bands sub-band
%   modif      (if present) modification structure: modifies accessed primary files
%              e.g. adding signals or sources; see bsd_acc_modif
%              [] no modification
%   modifpost  (if present) modification after the band extraction

% Snag Version 2.0 - October 2016
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

if isstruct(addr)
    ant=addr.ant;
    runame=addr.runame;
    tim=addr.tim;
    freq=addr.freq;
    if isfield(addr,'mode')
        mode=addr.mode;
    end
    if isfield(addr,'modif')
        modif=addr.modif;
    end
    if isfield(addr,'modifpost')
        modifpost=addr.modifpost;
    end
    addr=addr.addr;
end

dt0=0.1; % ATTENTION !!! important for mode 21. Use an info.dat in addr
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

if mode == 21
    inifr1=freq(1);
    bandw1=freq(2)-freq(1);
    [inifr,bandw,dt]=bsd_orthoband_acc(inifr1,bandw1,dt0);
    freq(1)=inifr;
    freq(2)=inifr+bandw;
    fprintf(' mode 21: freq changed  freq = %f %f \n',freq)
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
end

ictim=1;
if length(tim) == 0
    tim=[t_ini_run t_fin_run];
    ictim=0;
end
 
if ictab == 1
    tab_name=['BSD_tab_' runame '_' ach];

    load([addr dirsep 'BSD' dirsep tab_name]);
    eval(['tab=' tab_name ';'])

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
else        
    tab_name=['BSD_str_' runame '_' ach];

    load([addr dirsep 'BSD' dirsep tab_name]);
    eval(['tab=' tab_name ';'])

    ltab=length(tab);

    for i = 1:ltab
        name{i}=tab(i).name;
        path{i}=tab(i).path;
        antenna{i}=tab(i).antenna;
        run{i}=tab(i).run;
        cal{i}=tab(i).cal;
        t_ini(i)=tab(i).t_ini;
        t_fin(i)=tab(i).t_fin;
        fr_ini(i)=tab(i).fr_ini;
        fr_fin(i)=tab(i).fr_fin;
        filMbyt(i)=tab(i).filMbyt;
    end
end

if length(tim) == 2  %% CONTROLLARE
    it=find(t_ini < tim(2) & t_fin > tim(1));
else
    it=1:length(t_ini);
end

if length(freq) == 2  %% CONTROLLARE
    ifr=find(fr_ini(it) < freq(2) & fr_fin(it) > freq(1));
else
    ifr=find(fr_ini(it) <= freq(1) & fr_fin(it) > freq(1));
end

ii=it(ifr);

BSD_tab_out=bsd_seltab(tab,ii);

out0=check_bsd_table(tab)
out=check_bsd_table(BSD_tab_out)

kt=out.kt;
kfr=out.kfr;

BSD_tab_out=bsd_seltab(tab,ii,'kt',kt,'kfr',kfr);

if length(freq) == 1
    band=out.frange;
else
    band=freq;
end

if band(1) < out.frange(1)
    band(1)=out.frange(1);
    fprintf('minimum frequency %f limited at %f \n',freq(1),band(1));
end

if band(2) > out.frange(2)
    band(2)=out.frange(2);
    fprintf('maximum frequency %f limited at %f \n',freq(2),band(2));
end

if length(tim) == 1
    tim=out.trange;
end

if tim(1) < out.trange(1)
    tim(1)=out.trange(1);
    fprintf('minimum time limited at %f \n',tim(1));
end

if tim(2) > out.trange(2)
    tim(2)=out.trange(2);
    fprintf('maximum time limited at %f \n',tim(2));
end

if mode > 0
    switch mode
        case 1
            disp(' *** Not yet implemented')
        case 2
            bsd_out=bsd_concsubband(addr,BSD_tab_out,band,modif);
            if ictim == 1
                bsd_out=cut_bsd(bsd_out,tim);
            end
        case 20
            if out.single_fr == 0
                disp(' *** error for mode 2')
                return
            end
            for i = 1:out.N
                [in, name]=load_tab_bsd(addr,BSD_tab_out,i,modif);
                sb=bsd_subband(in,BSD_tab_out,band-out.frange(1));
                if exist('modifpost','var')
                    sb=bsd_acc_modif(sb,modifpost);
                end
                if i == 1
                    bsd_out=sb; 
                else
                    bsd_out=conc_bsd(bsd_out,sb)
                end
            end
            if ictim == 1
                bsd_out=cut_bsd(bsd_out,tim);
            end
        case 21
            for i = 1:out.N
                [in, name]=load_tab_bsd(addr,BSD_tab_out,i,modif);
                sb=bsd_subband(in,BSD_tab_out,band-out.frange(1));
                if exist('modifpost','var')
                    sb=bsd_acc_modif(sb,modifpost);
                end
                if i == 1
                    bsd_out=sb; 
                else
                    bsd_out=conc_bsd(bsd_out,sb)
                end
            end
            if ictim == 1
                bsd_out=cut_bsd(bsd_out,tim);
            end
        case 3
            if out.single_t == 0
                disp(' *** error for mode 3')
                return
            end
            bsd_out=bsd_largerband(BSD_tab_out,tim(1),tim(2),addr)
        case 4
            bsd_out=bsd_interband(addr,BSD_tab_out,freq,tim); 
    end
end