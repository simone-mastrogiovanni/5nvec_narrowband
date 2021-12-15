dir_file_followupItex=dir('J*/reduce_followI.m');
fp=fopen('followupII_stage.tex','w')
fprintf(fp,'\\documentclass[10pt,a4paper,landscape]{article}\n \\usepackage[left=2cm, right=2cm, top=2cm]{geometry} \n \\usepackage[utf8]{inputenc}\n\\usepackage[english]{babel}\n\\usepackage{amsmath}\n\\usepackage{amsfonts}\n');
fprintf(fp,'\\usepackage{color}\n\\usepackage{amssymb}\n\\usepackage{graphicx}\n\\usepackage{wrapfig}\n\\usepackage{lscape}\n\\usepackage{rotating}\n\\usepackage{epstopdf}\n\\begin{document}\n');
fprintf(fp,'\\newcommand*{\\cons}[1]{{\\bf \\color{red} Further considerations on this Pulsar:}}\n');
fprintf(fp,'The second step of the follow-up will consist on the following tests:\n');
fprintf(fp,'\\begin{itemize}\n');
fprintf(fp,'\\item Inject 100 software injections with amplitude equal to the one of the best IFO (joint analysis if they are similar). Check the histograms for the recovered parameters.\n');
fprintf(fp,'\\item Check the plots performed for the follow-up I stage with the distributions obtained from the software injections.\n');
fprintf(fp,'\\item Check the estimated amplitude with the distribution of the upper-limits over the narrow-band\n');
fprintf(fp,'\\end{itemize}\n');


for indx_pulsar=1:1:length(dir_file_followupItex)
    clearvars -except indx_pulsar fp dir_file_followupItex
    [~,name_f,~] = fileparts(dir_file_followupItex(indx_pulsar).folder);
    name_f
    name_f_name=name_f;
    for ici=1:1:length(name_f_name)
        if name_f_name(ici)=='_'
            name_f_name(ici)=' ';
        end
    end
    
    cd(dir_file_followupItex(indx_pulsar).folder);
    
    dir_follow2=dir('followIIstage_Cand*.mat');
    dir_follow1=dir('followIstage_Cand*.mat');
    
    if isempty(dir_follow2)
        continue
    end
    
    fprintf(fp,'\\section{%s}\n',name_f_name);
    fprintf(fp,'\\cons \\newline \n');
    n_candidates=length(dir_follow2);
    fprintf(fp,'For this pulsar we have performed the II stage follow-up for %d outliers.\n',n_candidates);
    
    if ~exist('followIIstage_directory','dir')
        mkdir('followIIstage_directory')
    end
    
    fontsizess=14;
    
    for i_candII=1:1:n_candidates
        load(dir_follow2(i_candII).name);
        load(dir_follow1(i_candII).name);
        
        num_IFO = length(fupinj_IFO{1});
        
        for indx_ifo=1:1:num_IFO
            IFO_SNR = fupinj_IFO{2}{indx_ifo}.';
            IFO_H=fupinj_IFO{3}{indx_ifo}.';
            IFO_cohe=(fupinj_IFO{4}{indx_ifo}.');
            
            IFO_SNR_fw = SNR_IFO{indx_ifo};
            IFO_cohe_fw=cohe_IFO{indx_ifo};
            t_IFO_fw=1:1:length(IFO_cohe_fw);
            IFO_H0_fw=ones(size(t_IFO_fw))*H0_proxy;
            
            for i_label=1:1:length(fupinj_IFO{1}{indx_ifo}(1,:))
                time_IFO{i_label}=num2str(fupinj_IFO{1}{indx_ifo}(1,i_label),'%.2f');
            end
            
            subplot(num_IFO+1,3,(indx_ifo-1)*3+1);
            violinplot((IFO_SNR.'),time_IFO,'ViolinColor',[0 1 1]);
            plot(t_IFO_fw,IFO_SNR_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
            xlabel('Fraction of data samples')
            ylabel(['SNR IFO#',num2str(indx_ifo)])
            
            subplot(num_IFO+1,3,(indx_ifo-1)*3+2);
            violinplot((IFO_H.'),time_IFO,'ViolinColor',[0 1 1]);
            plot(t_IFO_fw,IFO_H0_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
            xlabel('Fraction of data samples')
            ylabel(['H0 IFO#',num2str(indx_ifo)])
            
            subplot(num_IFO+1,3,(indx_ifo-1)*3+3);
            violinplot((IFO_cohe.'),time_IFO,'ViolinColor',[0 1 1]);
            plot(t_IFO_fw,IFO_cohe_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
            xlabel('Fraction of data samples')
            ylabel(['coherence IFO#',num2str(indx_ifo)])
            
        end
        
        jointSNR=fupjointinj{2}.';
        joint_H=(fupjointinj{3}.');
        joint_cohe=(fupjointinj{4}.');
        
        joint_SNR_fw = SNR;
        joint_cohe_fw=cohe;
        t_joint_fw=1:1:length(joint_cohe_fw);
        IFO_joint_fw=ones(size(t_joint_fw))*H0_proxy;
        
        for i_label=1:1:length(fupjointinj{1}(1,:))
            time_l_joint{i_label}=num2str(fupjointinj{1}(1,i_label),'%.2f');
        end
        
        indx_ifo=num_IFO+1;
        
        subplot(num_IFO+1,3,(indx_ifo-1)*3+1);
        violinplot((jointSNR.'),time_l_joint,'ViolinColor',[0 1 1]);
        plot(t_joint_fw,joint_SNR_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
        xlabel('Fraction of data samples')
        ylabel(['SNR Joint',num2str(indx_ifo)])
        
        subplot(num_IFO+1,3,(indx_ifo-1)*3+2);
        violinplot((joint_H.'),time_l_joint,'ViolinColor',[0 1 1]);
        plot(t_joint_fw,IFO_joint_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
        xlabel('Fraction of data samples')
        ylabel(['H0 Joint',num2str(indx_ifo)])
        
        subplot(num_IFO+1,3,(indx_ifo-1)*3+3);
        violinplot((joint_cohe.'),time_l_joint,'ViolinColor',[0 1 1]);
        plot(t_joint_fw,joint_cohe_fw,'kd--','Linewidth',1.0,'MarkerFaceColor','k');
        xlabel('Fraction of data samples')
        ylabel(['coherence Joint',num2str(indx_ifo)])
        %set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,[dir_follow2(i_candII).folder,filesep,'followIIstage_directory/C',dir_follow2(i_candII).name(end-8:end-4),'_inj_full.pdf']);
        close all

        
    end
    
    
    for i_candII=1:1:n_candidates
        load(dir_follow2(i_candII).name);
        load(dir_follow1(i_candII).name);
                
        fprintf(fp,'\\newpage \n \\clearpage \n');
        fprintf(fp,'\\subsection{%s of %s}\n',dir_follow2(i_candII).name(end-8:end-4),name_f_name);
        file3=[dir_follow2(i_candII).folder,filesep,'followIIstage_directory/C',dir_follow2(i_candII).name(end-8:end-4),'_inj_full.pdf'];
        
        fprintf(fp,'\\begin{figure}[h!] \n');
        fprintf(fp,'\\centering\n');
        fprintf(fp,['\\includegraphics[width=1.0\\textwidth]{',file3,'}\n']);
        fprintf(fp,'\\caption{Behaviour of some estimators of the injections (violin plots) with respect to the integration time. Cyan: joint, gree: LLO, red: LHO. The injected amplitude is %f and it is indicated by the dashed blue line in the frist row of the plots.}\n',H0_proxy);
        fprintf(fp,'\\end{figure}\n');
        fprintf(fp,'\\newpage \n \\clearpage \n');
    end
    
    
    
    cd ..
    
    clearvars -except indx_pulsar fp dir_file_followupItex dir_follow2
    
    
end
fprintf(fp,'\\end{document}\n');
fclose(fp);