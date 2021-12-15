function [bsd_out,BSD_tab_out,stpar,freq1]=bsd_funblock_1(addr,ant,runame,tim,target,extr_half_band)
% bsd_block_1
%
% extracts data to analyze
%   needs procedure bsd_block_0
%   needs data extr_half_band
%   produces bsd_out,BSD_tab_out,stpar
%

msgbox(sprintf('bsd_funblock_1 : %s %s %s %f %s',addr,ant,runame,tim,target.name))
pause(0.5)

SD=86164.09053083288;

if ~exist('extr_half_band','var')
    extr_half_band=0.05;
end

frdum=target.f0;

freqdum=[frdum-extr_half_band,frdum+extr_half_band];

BSD_tab_out=bsd_tabout(addr,ant,runame,tim,freqdum);
ntab=length(BSD_tab_out.t_ini);
T00=(BSD_tab_out.t_ini(1)+BSD_tab_out.t_fin(ntab))/2;
T0=BSD_tab_out.t_ini(1);
Tobs=(BSD_tab_out.t_fin(ntab)-BSD_tab_out.t_ini(1))*86400;
dsd0=1/Tobs^2; dsd=dsd0
target=new_posfr(target,T0);

frdec=target.f0;
freq=[frdec-0.05,frdec+0.05];
freq1=[frdec-5.1/SD,frdec+5.1/SD];
mode=1; 

[bsd_out,BSD_tab_out,stpar]=bsd_lego(addr,ant,runame,tim,freq,mode);
