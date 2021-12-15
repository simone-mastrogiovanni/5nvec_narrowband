function out=bsd_interband(addr,tab,band,tim,dt)
% inter-band reconstruction

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('dt','var')
    icortho=0;
else
    icortho=1;
end
file=file_tab_bsd(addr,tab);
nfiles=length(file)';
nofiles=0;
chtab=check_bsd_table(tab);
frange=chtab.frange;
trange=chtab.trange;
kt=chtab.kt; 
kfr=chtab.kfr;

sband=frange(2)-frange(1);
basefr=frange(1);

ukt=unique(kt);
ukfr=unique(kfr);

for it = min(ukt):max(ukt)
    ii=find(kt == it);
    tab1=bsd_seltab(tab,ii); %tab1,it,tim(1),tim(2),tab1.t_ini
    tim1=max(tim(1),tab1.t_ini(1));
    tim2=min(tim(2),tab1.t_fin(1)); %tim1,tim2
    out1=bsd_large_band(tab1,tim1,tim2,addr); % it,out1,tab1  ATTENZIONE, CONTROLLARE bsd_subband
    if icortho == 1
        out1=bsd_subband_ortho(out1,tab1,band-basefr); % out1
    else
        out1=bsd_subband(out1,tab1,band-basefr); % out1
    end
        
    if it == 1
        out=out1;
    else
        out=conc_bsd(out,out1);
    end
%     for ifr = ukfr
%     end
end