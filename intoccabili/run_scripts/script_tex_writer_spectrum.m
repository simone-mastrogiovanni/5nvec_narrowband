dir_file_followupItex=dir('J*/candidates_FAP_1mille.mat');
fp=fopen('spectrum_around_the_outliers_collection.tex','w');

%----------------------------

fprintf(fp,'\\documentclass[10pt,a4paper]{article}\n\\usepackage[utf8]{inputenc}\n\\usepackage[english]{babel}\n\\usepackage{amsmath}\n\\usepackage{amsfonts}\n');
fprintf(fp,'\\usepackage{color}\n\\usepackage{amssymb}\n\\usepackage{graphicx}\n\\usepackage{wrapfig}\n\\usepackage{lscape}\n\\usepackage{rotating}\n\\usepackage{epstopdf}\n\\begin{document}\n');
fprintf(fp,'\\newcommand*{\\cons}[1]{{\\bf \\color{red} Further considerations on this Pulsar:}}\n');

for indx_pulsar=1:1:length(dir_file_followupItex)
     clearvars -except indx_pulsar fp dir_file_followupItex
    [~,name_f,~] = fileparts(dir_file_followupItex(indx_pulsar).folder);
    name_f
    cd(dir_file_followupItex(indx_pulsar).folder);
    dir_file_spec=dir('spectrum_around_*.pdf');
    if length(dir_file_spec) == 0
        continue
    end
    fprintf(fp,'\\section{%s}\n',name_f);
    
    for indx_spec=1:1:length(dir_file_spec)
        fprintf(fp,'\\begin{figure}[h!] \n');
        fprintf(fp,'\\centering\n');
        filepath = [dir_file_spec(indx_spec).folder,filesep,dir_file_spec(indx_spec).name];
        fprintf(fp,['\\includegraphics[width=1\\textwidth]{',filepath,'}\n']);
        fprintf(fp,'\\caption{Spectrum of }\n');
        fprintf(fp,'\\end{figure}\n');
    end
        
    
    fprintf(fp,'\\newpage \n \\clearpage \n');
    
    
    cd ..
    
    clearvars -except indx_pulsar fp dir_file_followupItex
    
    
end
fprintf(fp,'\\end{document}\n');
fclose(fp);