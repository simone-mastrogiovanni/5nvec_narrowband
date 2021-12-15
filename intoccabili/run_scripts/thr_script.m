dir_file=dir('J*/compose_script*');

for indx_p=23:1:length(dir_file)
   cd(dir_file(indx_p).folder);
   %if indx_p==6
   %['deca/',dir_file(indx_p).folder(end-10:end),'_0_deca_vector_results.mat']
   %   candidates=compute_thr(['deca/',dir_file(indx_p).folder(end-10:end),'_0_deca_vector_results.mat'],'composed_file.mat');

   %else
   dir_sd=dir('deca/J*_deca_vector_results.mat');
   length(dir_sd)
   ['deca/',dir_file(indx_p).name(end-11:end-2),'_0_deca_vector_results.mat']
   candidates=compute_thr( ['deca/',dir_file(indx_p).name(end-11:end-2),'_0_deca_vector_results.mat'],'composed_file.mat',0.001);
   %end
   save('candidates_FAP_1mille.mat','candidates');
   cd .. 
   close all
   clearvars -except indx_p dir_file
  
end