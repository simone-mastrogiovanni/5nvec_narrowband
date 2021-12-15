function [bsd_out,BSD_str_out,out]=bsd_access_str(addr,ant,run,tim,freq,mode,modif)
% data access (STRUCTURE VERSION for old Matlab)
%
%     bsd_out=bsd_access_str(addr,ant,run,tim,freq,mode,modif)
%
%    addr   path that contains BSD data master directory without the final dirsep
%    ant    antenna name
%    run    run name 
%    tim    [tini tfin] (mjd) ; if length(tim) = 1 the whole run
%    freq   [frini frfin] ; if length(freq) = 1 the full band with frini
%    mode   mode  = 0 only the output table
%                 > 0 creates the output bsd
%                 = 1 automatic
%                 = 2 sub-band, concatenates files
%                 = 3 sub-period, many bands
%                 = 4 inter-bands sub-band
%   modif   (if present) modification structure: modifies accessed primary files
%           e.g. adding signals or sources; see bsd_acc_modif

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

bsd_out=0;
icmod=0;

if exist('modif','var')
    icmode=1;
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

switch run
    case 'O1'
        t_ini_run=57277;
        t_fin_run=57369;
end

if length(tim) == 0
    tim=[t_ini_run t_fin_run];
end
        
tab_name=['BSD_str_' run '_' ach];

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

if length(tim) == 2  %% CONTROLLARE
    it=find(t_ini < tim(2) & t_fin > tim(1));
else
    it=1:length(t_ini);
end

if length(tim) == 2  %% CONTROLLARE
    ifr=find(fr_ini(it) <= freq(2) & fr_fin(it) >= freq(1));
else
    ifr=find(fr_ini(it) <= freq(1) & fr_fin(it) > freq(1));
end

ii=it(ifr);

BSD_str_out=bsd_seltab(tab,ii);

out0=check_bsd_table(tab)
out=check_bsd_table(BSD_str_out)

kt=out.kt;
kfr=out.kfr;

BSD_str_out=bsd_seltab(tab,ii,'kt',kt,'kfr',kfr);

% BSD_tab_out=table(name,path,antenna,run,cal,t_ini,...
%     t_fin,fr_ini,fr_fin,filMbyt,kt,kfr);

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
            if out.single_fr == 0
                disp(' *** error for mode 2')
                return
            end
            for i = 1:out.N
                [in, name]=load_tab_bsd(addr,BSD_str_out,i);
                sb=bsd_subband(in,BSD_tab_out,band-out.frange(1));
                if i == 1
                    bsd_out=sb; 
                else
                    bsd_out=conc_bsd(bsd_out,sb)
                end
            end
        case 3
            if out.single_t == 0
                disp(' *** error for mode 3')
                return
            end
            bsd_out=bsd_largerband(BSD_str_out,tim(1),tim(2),addr)
        case 4
            bsd_out=bsd_interband(addr,BSD_str_out,freq,tim); 
    end
end