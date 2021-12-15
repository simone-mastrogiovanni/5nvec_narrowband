dir_file=dir('*/recos*');
for i=1:1:length(dir_file)
   cd(dir_file(i).folder); 
   run(dir_file(i).name);
   cd ..
end
