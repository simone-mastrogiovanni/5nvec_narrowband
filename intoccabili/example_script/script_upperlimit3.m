%addpath('D:\prove_nuove\commented_programs\');
%addpath('/storage/users/simone/Work_tesi/f_compiled/pss2/');

dtout=1; % Metti il tempo di down sampling
secondtime=num2str(57275); % METTI TEMPO RIF
selpath_H='D:\prove_nuove\P0H\'; % Metti selpath H, stessa dove sono gli originali Cancella i selection
inseg_H='D:\prove_del_treno\O1_H1_segments_science_full.txt'; % Metti file per riduzione H, stesso originali
cut_arr_H=num2str([57351 57399],15); % Metti cut_array, stesso originale
f_cent_H=num2str(265.5,15); % Metti freq centrale, stessa originali
f_band_H=num2str(0.8,15); % Metti banda esplorata, stesstmp_upperlimit_L2.mata originale

selpath_L='D:\prove_nuove\P0L\'; % Metti selpath L, stessa dove sono gli originali Cancella i selection
inseg_L='D:\prove_del_treno\O1_L1_segments_science_full.txt'; % Metti file per riduzione L, stesso originali
cut_arr_L=cut_arr_H; % Metti cut_array, stesso originale
f_cent_L=f_cent_H; % Metti freq centrale, stessa originali
f_band_L=f_band_H; % Metti banda esplorata, stessa originale

binfsid=2.417867460243005e-07; % INSERT THE BIN 


timepath_H='D:\prove_nuove\P0H\C01Hp0_pulsar_0_timevar.mat'; % metti file temporale per H
mainfile_H='D:\prove_nuove\P0H\C01Hp0_pulsar_0data_part1.mat'; % file principale per H
timepath_L='D:\prove_nuove\P0L\C01Lp0_pulsar_0_timevar.mat'; % metti file temporale per L
mainfile_L='D:\prove_nuove\P0L\C01Lp0_pulsar_0data_part1.mat'; % metti file principale per L


Ninj=1; % numero di onde che vuoi iniettare
Npk=1e3; % numeri di pk da iniettare, uguali al reduction
dfpk=1e-4; % Consistente con reduce
dfpk=floor(dfpk/binfsid)*binfsid

load(timepath_H);
load(mainfile_H,'source','ant','t0','pars');

source_H=source;
siout_H=siout; % Si carica sorgente per H
ant_H=ant; % Si carica antenna H
t0_H=t0; % tempo iniziale per H
virgin_pars_H=pars;
g_ein=gtime-g_p-g_tnot;
tt_H=g_tnot+g_ein;
g_p_H=g_p;



load(timepath_L);
load(mainfile_L,'source','ant','t0','pars');

siout_L=siout;
source_L=source; % Si carica sorgente per L
ant_L=ant; % Si carica antenna L
t0_L=t0; % tempo iniziale per L

g_ein=gtime-g_p-g_tnot;
tt_L=g_tnot+g_ein;
g_p_L=g_p;



virgin_pars_L=pars;

whos

for i=1:1:Ninj 
    freqrandom=rand;
    source_H.f0=round((str2double(f_cent_H)-str2double(f_band_H)/2+freqrandom*dfpk)/binfsid)*binfsid; % METTI FREQUENZA IN CUI INIZI AD INIETTARE E' multiplo di binfsid
    sdrand=(rand*(50)-25); % Metti i termini di spin-down da simulare

    
    
    source_H.sdindex=round(sdrand); % Si mette un nuovo campo per l'sdindexmodificato00000000000000000000000000000000000000000000000000
    source_H.df0=virgin_pars_H.df0+sdrand*binfsid^2; % Qui si genera lo spin-down casuale
    source_H.fepoch=str2double(secondtime);
    source_H.pepoch=str2double(secondtime);
    
    %source_H.df0=0
    %source_H.ddf0=0
    
    
    
    source_H.eta=-1+rand*2; %$Genera parametri di onda casuali
    source_H.psi=(-pi/2+pi*rand)*180/pi;
    source_H.eta=0.16
    source_H.psi=25
    source_H.h=1e-6 % Metti una determinata ampiezza seria
    outcell=gen_sig_dopp(source_H,ant_H,tt_H,g_p_H,t0_H,Npk,dfpk,dtout);
    gg_sc=outcell{1};
    wave=outcell{2};
    save([selpath_H,'selection_for_upper.mat'],'gg_sc');
%     load(mainfile_H,'in','ibias','ext1','ioutb','dtout','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
%     g=hsim.';
%     source=source_H;
%     save('tmp_upperlimit_H2.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
%     if exist('ioutin','var')
%     save('tmp_upperlimit_H2.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr','ioutin');
%     else
%             save('tmp_upperlimit_H2.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
% 
%     end
    reduce_for_upper(secondtime,selpath_H,timepath_H,['injection1_H_n_',num2str(i),'_'],mainfile_H,inseg_H,f_cent_H,f_band_H,num2str(0),num2str(0),cut_arr_H,num2str(0));
    source_L=source_H
    
    %source_L.df0=0
    %source_L.ddf0=0
    
   
    outcell=gen_sig_dopp(source_L,ant_L,tt_L,g_p_L,t0_L,Npk,dfpk,dtout);
    gg_sc=outcell{1};    
    wave=outcell{2};
    save([selpath_L,'selection_for_upper.mat'],'gg_sc');
%     load(mainfile_L,'in','ibias','ext1','ioutb','dtout','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
%     g=hsim.';
%     source=source_L;
% 
%     if exist('ioutin','var')
%     save('tmp_upperlimit_L2.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr','ioutin');
%     else
%             save('tmp_upperlimit_L2.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
% 
%     end
    reduce_for_upper(secondtime,selpath_L,timepath_L,['injection1_L_n_',num2str(i),'_'],mainfile_L,inseg_L,f_cent_L,f_band_L,num2str(0),num2str(0),cut_arr_L,num2str(0));
    inj_wave{i}=wave;
    i
end
save('inj_waves_file_crab.mat','inj_wave')
