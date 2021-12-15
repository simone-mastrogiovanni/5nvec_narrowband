% Launch this script from the pulsar folder

set(0,'DefaultFigureVisible','off')
i_cand=17; %Candidate label that we are going to followup
detector_network='HLV';
DT=[35;70;105;140;175];  % Days to divide for the followup
DT=[175];
folding=1;
out_string = '_2';


%------------------------------------

load('candidates_FAP_1mille.mat')
load(['followIstage_Cand',num2str(i_cand),'.mat'])

H0_proxy=H0(end);% Mettere ampiezza da studiare qui
fprintf('Injecting a signal with amplitude %f \n',H0_proxy)
clearvars -except i_cand H0_proxy out_string candidates H0_proxy gg detector_network folding DT
n_sd=candidates{2}.rcountsd(i_cand);
sd_cand=candidates{2}.spindown(i_cand);
freq_cand=candidates{2}.frequency(i_cand);
run('reduce_followI.m')

number_IFOs=length(detector_network);

for indx_ifo=1:1:number_IFOs
    cd([detector_network(indx_ifo),'/sdindex']);
    dir_temp=dir(['*sd_index=',num2str(n_sd),'.mat']);
    load(dir_temp.name);
    gg{indx_ifo}=gg_sc_clean;

    switch detector_network(indx_ifo)
        case 'H'
            ant{indx_ifo}=ligoh;
            
        case 'L'
            ant{indx_ifo}=ligol;
            
        case 'V'
            ant{indx_ifo}=virgo;
            
        otherwise
            stooooop
    end
    delete(dir_temp.name);
    cont_temp=cont_gd(gg{indx_ifo});
    sour=cont_temp.corrections_par;
    cd ..
    cd ..
end

sour.f0=freq_cand;
sour.df0=sd_cand;
clearvars -except sour gg out_string ant i_cand H0_proxy DT detector_network folding

[fupinj_IFO,fupjointinj]=driving_test_SNR_narrow_band(gg,ant,sour,folding,DT,H0_proxy);

save(['followIIstage_Cand',num2str(i_cand),out_string,'.mat']);

clear
close all
