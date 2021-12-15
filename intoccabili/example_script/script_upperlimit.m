
addpath('/storage/users/simone/commented_programs/');
addpath('/storage/users/simone/Work_tesi/f_compiled/pss2/');

selpath_H='/storage/users/simone/ligoh_O1_cal/J2229_6114/sdindex/'; % Metti selpath H, stessa dove sono gli originali Cancella i selection
inseg_H='/storage/users/simone/O1_H1_segments_science_full.txt'; % Metti file per riduzione H, stesso originali
cut_arr_H=num2str([0 0]); % Metti cut_array, stesso originale
f_cent_H=num2str(38.715313659746649); % Metti freq centrale, stessa originali
f_band_H=num2str(0.0774); % Metti banda esplorata, stessa originale

selpath_L='/storage/users/simone/ligol_O1_cal/J2229_6114/sdindex/'; % Metti selpath L, stessa dove sono gli originali Cancella i selection
inseg_L='/storage/users/simone/O1_L1_segments_science_full.txt'; % Metti file per riduzione L, stesso originali
cut_arr_L=cut_arr_H; % Metti cut_array, stesso originale
f_cent_L=f_cent_H; % Metti freq centrale, stessa originali
f_band_L=f_band_H; % Metti banda esplorata, stessa originale



timepath_H='/storage/users/simone/ligoh_O1_cal/J2229_6114/J2229H_J2229-6114_timevar.mat'; % metti file temporale per H
mainfile_H='/storage/users/simone/ligoh_O1_cal/J2229_6114/J2229H_J2229-6114data_part1.mat'; % file principale per H
timepath_L='/storage/users/simone/ligol_O1_cal/J2229_6114/J2229L_J2229-6114_timevar.mat'; % metti file temporale per L
mainfile_L='/storage/users/simone/ligol_O1_cal/J2229_6114/J2229L_J2229-6114data_part1.mat'; % metti file principale per L


Ninj=100; % numero di onde che vuoi iniettare
Npk=773; % numeri di pk da iniettare, uguali al reduction
dfpk=1e-4; % Ogni quanta freq li devo iniettare= alla sottobanda

load(timepath_H);
load(mainfile_H,'source','ant','t0','pars');

siout_H=siout;
source_H=source; % Si carica sorgente per H
ant_H=ant; % Si carica antenna H
t0_H=t0; % tempo iniziale per H
virgin_pars_H=pars;
g_ein=gtime-g_p-g_tnot;
tt_H=g_tnot+g_ein;
tt2_H=0.5*tt_H.^2;
tt3_H=(1/6)*tt_H.^3;
g_p_H=g_p;


load(timepath_L);
load(mainfile_L,'source','ant','t0','pars');

siout_L=siout;
source_L=source; % Si carica sorgente per L
ant_L=ant; % Si carica antenna L
t0_L=t0; % tempo iniziale per L

g_ein=gtime-g_p-g_tnot;
tt_L=g_tnot+g_ein;
tt2_L=0.5*tt_L.^2;
tt3_L=(1/6)*tt_L.^3;
g_p_L=g_p;

virgin_pars_L=pars;

whos

for i=1:1:Ninj 
    freqrandom=rand;
    source_H.f0=str2double(f_cent_H)-str2double(f_band_H)/2+freqrandom*9.435579664929356e-08; % METTI FREQUENZA IN CUI INIZI AD INIETTARE
    sdrand=(rand*(6)-3); % Metti i termini di spin-down da simulare
    source_H.sdindex=round(sdrand); % Si mette un nuovo campo per l'sdindexmodificato00000000000000000000000000000000000000000000000000
    source_H.df0=virgin_pars_H.df0+sdrand*9.435579664929356e-08^2; % Qui si genera lo spin-down casuale
    
    %source_H.df0=0
    %source_H.ddf0=0
    
    source_H.eta=-1+rand*2; %$Genera parametri di onda casuali
    source_H.psi=(-pi/2+pi*rand)*180/pi;
    source_H.h=1e-6; % Metti una determinata ampiezza seria
    
    [hsim,wave]=gen_sig_dopp(source_H,ant_H,tt_H,tt2_H,tt3_H,g_p_H,t0_H,Npk,dfpk);
        
    
    load(mainfile_H,'in','ibias','ext1','ioutb','dtout','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
    g=hsim.';
    pars.df0=source_H.df0;
    pars.t0=t0_H;
    save('tmp_upperlimit_H.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
    if exist('ioutin','var')
    save('tmp_upperlimit_H.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr','ioutin');
    else
            save('tmp_upperlimit_H.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');

    end
    
    if exist([selpath_H,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')
    igini=floor(round(1.0/dtout)*siout_H{1})+round(1.0/dtout)*ibias;
    igfin=ioutb+length(P)-1; %$ AUTOCONSISTENTE CON PSS_1
    gar_new=g(igini:igfin);
    
    load([selpath_H,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gar')
    izero=find(gar==0); % Per mettere in maniera giusta gli zeri
    gar_new(izero)=0;
    gar=gar_new;
    save([selpath_H,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gar','T0','dtout','pars')
    end
    reduce_for_upper(selpath_H,timepath_H,['injection_H_n_',num2str(i),'_'],'tmp_upperlimit_H.mat',inseg_H,f_cent_H,f_band_H,num2str(0),num2str(0),cut_arr_H,num2str(0),num2str(0));

    source_L.f0=source_H.f0; % METTI FREQUENZA IN CUI INIZI AD INIETTARE
    source_L.sdindex=round(sdrand); % Si mette un nuovo campo per l'sdindexmodificato00000000000000000000000000000000000000000000000000
    source_L.df0=source_H.df0; % Qui si genera lo spin-down casuale
    
    %source_L.df0=0
    %source_L.ddf0=0
    
    source_L.eta=source_H.eta; %$Genera parametri di onda casuali
    source_L.psi=source_H.psi;
    source_L.h=source_H.h; % Metti una determinata ampiezza seria % Mette le due sorgenti uguali
    
    [hsim,wave]=gen_sig_dopp(source_L,ant_L,tt_L,tt2_L,tt3_L,g_p_L,t0_L,Npk,dfpk);
        
    
    load(mainfile_L,'in','ibias','ext1','ioutb','dtout','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');
    g=hsim.';
    pars.df0=source_L.df0;
    pars.t0=t0_L;
    if exist('ioutin','var')
    save('tmp_upperlimit_L.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr','ioutin');
    else
            save('tmp_upperlimit_L.mat','in','ibias','ext1','ioutb','g','dtout','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');

    end
    if exist([selpath_L,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')
    igini=floor(round(1.0/dtout)*siout_L{1})+round(1.0/dtout)*ibias;
    igfin=ioutb+length(P)-1; %$ AUTOCONSISTENTE CON PSS_1
    gar_new=g(igini:igfin);
    
    load([selpath_L,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gar')
    izero=find(gar==0);
    gar_new(izero)=0;
    gar=gar_new;
    save([selpath_L,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gar','T0','dtout','pars')
    end
    reduce_for_upper(selpath_L,timepath_L,['injection_L_n_',num2str(i),'_'],'tmp_upperlimit_L.mat',inseg_L,f_cent_L,f_band_L,num2str(0),num2str(0),cut_arr_L,num2str(0),num2str(0));
    inj_wave{i}=wave;
    i
end
save('inj_waves_file_J2229.mat','inj_wave');
