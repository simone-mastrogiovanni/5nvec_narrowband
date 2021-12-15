addpath(genpath('/storage/users/mastrogiovanni/intoccabili_O3/'))
addpath(genpath('/opt/exp_software/virgo/Snag/'))  
load('out.mat','out');
IFOS=out.IFOS;

dir_file=dir('*/reduce_script*');
dir_file_2=dir('*/deca_script*');
dir_file_3=dir('*/post_reduce_script*');

for indx_script=1:1:1
   cd(dir_file(indx_script).folder); 
   dir_file(indx_script).name

   for i_IFO=1:1:length(IFOS)
   	delete([IFOS(i_IFO),'/sdindex/*'])
   end

   run(dir_file(indx_script).name);
   run(dir_file_2(indx_script).name)
   for i_IFO=1:1:length(IFOS)
  	cd([IFOS(i_IFO),'/sdindex/'])
   	delete('*part2*') 
   	cd ..
   	cd ..
   end   
   run(dir_file_3(indx_script).name)
   %cd deca
   %delete('*.mat')
   
   cd ..
   close all
end
