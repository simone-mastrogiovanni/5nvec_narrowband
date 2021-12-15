dir_file_followupItex=dir('J*/candidates_FAP_1mille.mat');
fp=fopen('followupI_stage_tex_document.tex','w');

fprintf(fp,'\\documentclass[10pt,a4paper]{article}\n\\usepackage[utf8]{inputenc}\n\\usepackage[english]{babel}\n\\usepackage{amsmath}\n\\usepackage{amsfonts}\n');
fprintf(fp,'\\usepackage{color}\n\\usepackage{amssymb}\n\\usepackage{graphicx}\n\\usepackage{wrapfig}\n\\usepackage{lscape}\n\\usepackage{rotating}\n\\usepackage{epstopdf}\n\\begin{document}\n');
fprintf(fp,'\\newcommand*{\\cons}[1]{{\\bf \\color{red} Further considerations on this Pulsar:}}\n');

for indx_pulsar=1:1:length(dir_file_followupItex)
    clearvars -except indx_pulsar fp dir_file_followupItex
    [~,name_f,~] = fileparts(dir_file_followupItex(indx_pulsar).folder);
    name_f
    cd(dir_file_followupItex(indx_pulsar).folder);
    load('candidates_FAP_1mille.mat');
    
    if isempty(candidates{2}.frequency)
        continue
    end
    
    fprintf(fp,'\\section{%s}\n',name_f);
    n_candidates=length(candidates{2}.frequency);
    
    fprintf(fp,'For this pulsar we have found %d outliers.  These  outliers  are summarized in the following table and in the following general plot\n',n_candidates);
    fprintf(fp,'\\begin{table}[h!]\n');
    fprintf(fp,'\\centering\n');
    fprintf(fp,'\\caption{Candidates found for the pulsar %s. First column: Name of the outlier, Second: Frequency, Third: Spin-down value, Fourth: Spin-down index Narrow-band, Fifth: p-value, Sixth: p-value with lookelsewhere effect, Seventh: Vetoed by who?}\n',name_f);
    fprintf(fp,'\\begin{tabular}{l|c|c|c|c|c|}\n');
    fprintf(fp,'\\textbf{Name}&Freq.[Hz]&S-D[Hz/s]&S-D index&p-value&p-loe \\\\ \n');
    fprintf(fp,'\\hline \n');
    
    jcounter=1;
    cand_name=cell(1,n_candidates);
    
    for i_cand=1:1:n_candidates
        cand_name{i_cand}=['C',num2str(i_cand)];
        fprintf(fp,'%s & %f & %.4g & %d & %.4g & %.4g  \\\\ \n',cand_name{i_cand},candidates{2}.frequency(i_cand),candidates{2}.spindown(i_cand),candidates{2}.rcountsd(i_cand),candidates{2}.over_pvalue(i_cand),candidates{2}.pvalue(i_cand));
    end
    fprintf(fp,'\\end{tabular}\n');
    fprintf(fp,'\\end{table}\n');
    
    if ~exist('followIstage_directory','dir')
        mkdir('followIstage_directory');
    else
        
    end
    
    load('composed_file.mat')
    
    open('candidates_plot.fig')
    text(candidates{2}.frequency,candidates{2}.spindown,cand_name,'FontWeight','bold','Interpreter','latex')
    hold on
    xlim([min(r_fra) max(r_fra)])
    ylim([min(r_sd) max(r_sd)])
    saveas(gcf,'followIstage_directory/freq_sd_plane_recap.pdf')
    close all
    
    open('candidates_pvalues.fig')
    text(candidates{2}.frequency,candidates{2}.pvalue,cand_name,'FontWeight','bold','Interpreter','latex')
    hold on
    saveas(gcf,'followIstage_directory/pvalues_recap.pdf')
    close all
    
    fprintf(fp,'\\begin{figure}[h!] \n');
    fprintf(fp,'\\centering\n');
    
    fprintf(fp,['\\includegraphics[width=1\\textwidth]{',dir_file_followupItex(indx_pulsar).folder,'/followIstage_directory/freq_sd_plane_recap.pdf}\n']);
    fprintf(fp,'\\caption{Position of the outliers (red diamod) and not-vetoed outliers (green stars) in the frequency spin-down plane}\n');
    fprintf(fp,'\\end{figure}\n');
    
    fprintf(fp,'\\begin{figure}[h!] \n');
    fprintf(fp,'\\centering\n');
    fprintf(fp,['\\includegraphics[width=1\\textwidth]{',dir_file_followupItex(indx_pulsar).folder,'/followIstage_directory/pvalues_recap.pdf}\n']);
    fprintf(fp,'\\caption{Pvalues of the outliers (red diamod) and not-vetoed outliers (green stars). Top panel: overall pvalue. Bottom Panel: Takes into account the lookelsewhere effect}\n');
    fprintf(fp,'\\end{figure}\n');
    fprintf(fp,'\\newpage \n \\clearpage \n');
    
    
    
    
    dir_followC=dir('followIstage_Cand*');
    
    for i_cand=1:1:length(dir_followC)
        load(dir_followC(i_cand).name);
        fprintf(fp,'\\subsection{%s}\n',dir_followC(i_cand).name(end-8:end-4));
        figure;
        hold on;
        plot(t_SNR,SNR,'o-.')
        leg_arr{1}='joint';
        for i_IFO = 1:1:length(SNR_IFO)
            plot(t_SNR_IFO{i_IFO},SNR_IFO{i_IFO},'d--');
            leg_arr{i_IFO+1}=[num2str(i_IFO),' IFO'];
        end
        legend(leg_arr);
        xlabel('Fraction data samples');
        ylabel('SNR');
        set(gca,'FontSize',13);
        
        grid on;
        hold off;
        ppt = [dir_followC(i_cand).folder,filesep,'followIstage_directory/C',dir_followC(i_cand).name(end-7:end-4),'SNR.pdf'];
        saveas(gcf,ppt);
        
        fprintf(fp,'\\begin{figure}[h!] \n');
        fprintf(fp,'\\centering\n');
        fprintf(fp,['\\includegraphics[width=1\\textwidth]{',ppt,'}\n']);
        fprintf(fp,'\\caption{SNR evolution of the outlier}\n');
        fprintf(fp,'\\end{figure}\n');
        
        figure;
        hold on;
        plot(t_SNR,H0,'o-.')
        leg_arr{1}='joint';
        for i_IFO = 1:1:length(H0_IFO)
            plot(t_SNR_IFO{i_IFO},H0_IFO{i_IFO},'d--');
            leg_arr{i_IFO+1}=[num2str(i_IFO),' IFO'];
        end
        legend(leg_arr);
        xlabel('Fraction data samples');
        ylabel('H0');
        set(gca,'FontSize',13);
        grid on;
        hold off;
        
        ppt = [dir_followC(i_cand).folder,filesep,'followIstage_directory/C',dir_followC(i_cand).name(end-7:end-4),'H0.pdf'];
        saveas(gcf,ppt);
        
        fprintf(fp,'\\begin{figure}[h!] \n');
        fprintf(fp,'\\centering\n');
        fprintf(fp,['\\includegraphics[width=1\\textwidth]{',ppt,'}\n']);
        fprintf(fp,'\\caption{H0 evolution of the outlier}\n');
        fprintf(fp,'\\end{figure}\n');
        
        figure;
        hold on;
        plot(t_SNR,cohe,'o-.    ')
        leg_arr{1}='joint';
        for i_IFO = 1:1:length(cohe_IFO)
            plot(t_SNR_IFO{i_IFO},cohe_IFO{i_IFO},'d--');
            leg_arr{i_IFO+1}=[num2str(i_IFO),' IFO'];
        end
        legend(leg_arr);
        
        xlabel('Fraction data samples');
        ylabel('Coherence');
        set(gca,'FontSize',13);
        grid on;
        hold off;
        
        ppt = [dir_followC(i_cand).folder,filesep,'followIstage_directory/C',dir_followC(i_cand).name(end-7:end-4),'cohe.pdf'];
        saveas(gcf,ppt);
        
        fprintf(fp,'\\begin{figure}[h!] \n');
        fprintf(fp,'\\centering\n');
        fprintf(fp,['\\includegraphics[width=1\\textwidth]{',ppt,'}\n']);
        fprintf(fp,'\\caption{cohe evolution of the outlier}\n');
        fprintf(fp,'\\end{figure}\n');
        close all
        fprintf(fp,'\\newpage \n \\clearpage \n');
        
        
    end
    
    
    cd ..
    
    clearvars -except indx_pulsar fp dir_file_followupItex
    
    
end
fprintf(fp,'\\end{document}\n');
fclose(fp)