dir_file=dir('J*/candidates_FAP_1mille.mat');
IFO_list='HLV'; % IFO used
fveto=fopen('frequency_veto_file.txt','r'); % File with Pulsar folder- min_freq. exclude (fractional) - max_exclude
data_veto=textscan(fveto,'%s\t%f\t%f\n');
DT=[35;70;105;140;175];  % Days to divide for the followup
DT=[175];  % Days to divide for the followup
folding=0; % 1 if you want folding
out_string = '_2';


for indx_follow=1:1:length(dir_file)
    [~,name_f,~] = fileparts(dir_file(indx_follow).folder);
    name_f
    cd(dir_file(indx_follow).folder)
    load('candidates_FAP_1mille.mat')
    n_candidates=length(candidates{2}.frequency);
    if n_candidates==0
        continue
    end
    
    for i_cand=1:1:n_candidates
        n_sd=candidates{2}.rcountsd(i_cand);
        sd_cand=candidates{2}.spindown(i_cand);
        freq_cand=candidates{2}.frequency(i_cand);
        flag_veto=0;
        
        for i_veto=1:1:length(data_veto{1})
            
            switch name_f
                case data_veto{1}{i_veto}
                    if (freq_cand>=(data_veto{2}(i_veto)+floor(freq_cand))) ...
                            && (freq_cand<=(data_veto{3}(i_veto)+floor(freq_cand)))
                        flag_veto=1;
                        
                    end
                otherwise
                    continue     
            end           
        end
        
        if flag_veto==1
            continue
        end
        fprintf('running_candidate %d',i_cand)
        run('reduce_followI.m')
        for indx_ifo=1:1:length(IFO_list)
            cd([IFO_list(indx_ifo),'/sdindex'])
            dir_temp=dir(['*sd_index=',num2str(n_sd),'.mat']);
            load(dir_temp.name);
            gg{indx_ifo}=gg_sc_clean;
            delete(dir_temp.name);
            switch IFO_list(indx_ifo)
                case 'H'
                    ant{indx_ifo}=ligoh;
                    
                case 'L'
                    ant{indx_ifo}=ligol;
                    
                case 'V'
                    ant{indx_ifo}=virgo;
                    
                otherwise
                    stooooop
            end
            cont_temp=cont_gd(gg{indx_ifo});
            sour=cont_temp.corrections_par;
            cd ..
            cd ..
        end
        sour.f0=freq_cand;
        sour.df0=sd_cand;
        clearvars -except DT folding out_string ant sour gg  name_f indx_follow dir_file i_cand data_veto IFO_list fveto candidates
        [t_SNR_IFO,SNR_IFO,H0_IFO,cohe_IFO,Stat_IFO,t_SNR,SNR,H0,cohe,Stat]=script_candidates(gg,ant,sour,DT,folding);
        save(['followIstage_Cand',num2str(i_cand),out_string,'.mat'],'sour','Stat_IFO','Stat','t_SNR_IFO','SNR_IFO','H0_IFO','cohe_IFO','t_SNR','SNR','H0','cohe');
        clearvars -except name_f DT out_string indx_follow dir_file i_cand  data_veto IFO_list fveto folding candidates
    end
    
end