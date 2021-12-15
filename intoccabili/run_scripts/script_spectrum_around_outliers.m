% Launch this script in the Narrowband folder. Just before entering the
% pulsars folders

dir_struct=dir('J*/composed_file.mat');
IFOs_name='HLV'; % Detectors to consider
n_vec=100; % Number of pieces

for i_p=1:1:length(n_vec)
    
    clearvars -except n_vec dir_struct i_p IFOs_name
    n_pieces=n_vec(i_p);
    
    for i=1:1:length(dir_struct)
        
        cd(dir_struct(i).folder);
        if ~isfile('candidates_FAP_1mille.mat')
            continue
        end
        load('candidates_FAP_1mille.mat');
        if isempty(candidates{2}.frequency)
            continue
        end
        
        [~,name_folder,~] = fileparts(dir_struct(i).folder);
        cd('deca')
        fprintf('Computing spectra of: %s \n',name_folder);
        load([name_folder,'_0_deca_vector_results.mat']);
        cd ..
        for i_IFO=1:1:length(IFOs_name)
            if isfolder(IFOs_name(i_IFO))
                cd(IFOs_name(i_IFO));
                cd('sdindex');
                loadfile=dir('selection*');
                load(loadfile.name)
                ggH=gg_sc;
                spectrum_H=gd_pows(ggH,'pieces',n_pieces);
                specH=y_gd(spectrum_H);
                tH=x_gd(gg_sc);
                tobsH=round(length(tH)/86400);
                freq=x_gd(spectrum_H);
                ii=find(freq>fra(1)-floor(fra(1))-1e-3 & freq<fra(end)-floor(fra(1))+1e-3);
                
                subplot(3,1,1)
                freq=x_gd(spectrum_H);
                ii=find(freq>fra(1)-floor(fra(1))-1e-3 & freq<fra(end)-floor(fra(1))+1e-3);
                spectrogram(y_gd(ggH),floor(length(y_gd(ggH))/n_pieces),floor(0.5*length(y_gd(ggH))/n_pieces),freq(ii(1)):(0.5*mean(diff(freq))):freq(ii(end)),1,'MinThreshold',-80,'psd')
                title(['Spectrogram L',IFOs_name(i_IFO),'O ',num2str(n_pieces),' pieces half interlaced']);
                
                subplot(3,1,2)
                freq=x_gd(spectrum_H);
                ii=find(freq>fra(1)-floor(fra(1))-1e-3 & freq<fra(end)-floor(fra(1))+1e-3);
                semilogy(freq(ii),(specH(ii)),'r');
                xlim([freq(ii(1)),freq(ii(end))])
                ylabel('Spectrum [1/Hz]','Interpreter','latex');
                xlabel('Frequency Hz','Interpreter','latex');
                title(['Average spectrum of L',IFOs_name(i_IFO),'O ',num2str(n_pieces),' pieces ',num2str(tobsH),' days of data']);
                
                
                subplot(3,1,3)
                spH=gd_pows(ggH);
                freq=x_gd(spH);
                ii=find(freq>fra(1)-floor(fra(1))-1e-3 & freq<fra(end)-floor(fra(1))+1e-3);
                spH=y_gd(spH);
                semilogy(freq(ii),(spH(ii)),'r');
                xlim([freq(ii(1)),freq(ii(end))])
                ylabel('Spectrum [1/Hz]','Interpreter','latex');
                xlabel('Frequency Hz','Interpreter','latex');
                title(['Spectrum of L',IFOs_name(i_IFO),'O ',num2str(tobsH),' days of data']);
                cd ..
                cd ..
                saveas(gcf,['spectrum_around_',IFOs_name(i_IFO),'_',num2str(n_pieces),'pieces.pdf']);
                close all
                
            end
        end
        
        cd ..
    end
end