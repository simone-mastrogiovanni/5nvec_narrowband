% Lo script fa principlmanete due cose; 1 Inietta dei sengali falsi con
% ampiezza della stima fatta e unifromemente distributiti in eta e psi e
%  e poi stima il rapporto SNR delle iniezioni
function [fupinj_IFO,fupjointinj]=driving_test_SNR_narrow_band(gg,ant,sour,folding,DT,H0_proxy)
% gg: cell array of candidates gds
% ant: antenna array of gds
% folding: 1 if folding otherwise not
% DT: Time array for the chunk divition in the form DT=[1day;30days;...]
% Amplitude signal to inject

number_of_IFOS=length(gg);




[S_anal,hp_anal,hc_anal,pentaAplusfft_anal,pentaAcrossfft_anal,data5_vec_anal, gg_IFO,gAp_IFO,gAc_IFO]=test_injection_narrow_band_true_signal(folding,gg,sour,ant);
[t_SNR_IFO,SNR_IFO,H0_IFO,cohe_IFO,Stat_IFO,t_SNR_joint,SNR_joint,H0_joint,cohe_joint,Stat_joint]=script_candidates(gg,ant,sour,DT,folding);

for indx_IFO=1:1:length(gg_IFO)
pentaAcrossfft_anal{indx_IFO}=pentaAcrossfft_anal{indx_IFO}.';
pentaAplusfft_anal{indx_IFO}=pentaAplusfft_anal{indx_IFO}.';
end

if folding==1
    out_cell_anal=coherence_simone(gg_IFO,0,pentaAplusfft_anal,pentaAcrossfft_anal);
else
    out_cell_anal=coherence_simone(gg_IFO,sour.f0,pentaAplusfft_anal,pentaAcrossfft_anal);
end
simwaves.H0=H0_proxy; % Metti H0 oppure usa quello della sorgente
% Il successivo for inietta le injection
for jj=1:1:100
    cosi=(rand*2-1); % uniform cosiota
    eta=-2*cosi/(1+cosi^2); % Eta generated
    psi=(rand*80-40)*pi/180; % Inserire come viene generato il parametro \psi in RAD
    eta_vec(jj)=eta;
    psi_vec(jj)=psi*180/pi;
    simwaves.psi=psi;
    simwaves.eta=eta;
    disp(sprintf('Injection number %d:',jj));
    sournew=sour;
    if folding==1
        fp=sour.f0+rand*100/86400+70/86400;
        fm=sour.f0-rand*100/86400-70/86400;
    else
        fp=sour.f0+rand*5e-5+70/86400;
        fm=sour.f0-rand*5e-5-70/86400;
    end
    ch=rand;
    if(ch>0.5)
        sournew.f0=fp;
    else
        sournew.f0=fm;
    end
    [out_cell_IFO, fup_IFO,out_cell_joint, fupjoint]=test_injection_narrow_band(DT,folding,simwaves,gg,gAp_IFO,gAc_IFO,sournew,ant,pentaAplusfft_anal,pentaAcrossfft_anal);
    
    
    for indx_ifo=1:1:number_of_IFOS
        
        
        fupinj_IFO{1}{indx_ifo}(jj,:)=fup_IFO{1}{indx_ifo}; % Time integration
        fupinj_IFO{2}{indx_ifo}(jj,:)=fup_IFO{2}{indx_ifo}; %SNR
        fupinj_IFO{3}{indx_ifo}(jj,:)=fup_IFO{3}{indx_ifo}; % H0
        fupinj_IFO{4}{indx_ifo}(jj,:)=fup_IFO{4}{indx_ifo};% Coherence
        fupinj_IFO{5}{indx_ifo}(jj,:)=fup_IFO{5}{indx_ifo};% Statistic
        
        %H0_esti_IFO{indx_ifo}(jj)=out_cell_IFO{indx_ifo}{1}(1);
        %eta_esti_IFO{indx_ifo}(jj)=out_cell_IFO{indx_ifo}{1}(2);
        %psi_esti_IFO{indx_ifo}(jj)=out_cell_IFO{indx_ifo}{1}(3);
        %phi0_esti_IFO{indx_ifo}(jj)=out_cell_IFO{indx_ifo}{1}(4);
        %cohe_IFO{indx_ifo}(jj)=out_cell_IFO{indx_ifo}{1}(5);
        
    end
    
    fupjointinj{1}(jj,:)=fupjoint{1};
    fupjointinj{2}(jj,:)=fupjoint{2};
    fupjointinj{3}(jj,:)=fupjoint{3};
    fupjointinj{4}(jj,:)=fupjoint{4};
    fupjointinj{5}(jj,:)=fupjoint{5}; % Statistic
    
    %H0_esti_joint(jj)=out_cell_joint{1}(1);
    %eta_esti_joint(jj)=out_cell_joint{1}(2);
    %psi_esti_joint(jj)=out_cell_joint{1}(3);
    %phi0_esti_joint(jj)=out_cell_joint{1}(4);
    %cohe_joint(jj)=out_cell_joint{1}(5);
    
    close all
end




end

