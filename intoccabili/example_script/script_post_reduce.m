prein='/Volumes/Simone_work/O2_narrowband/vela2/L/sdindex/J0835m4510_J0835m4510_days_57758-57990data_part2_sd_index='; % insert the first part of the file to reduce
postin='.mat'; % insert the second art of the file to reduce
i=1; 
for i=-17:1:17 % Insert the cycling indexes
   name=[prein,num2str(i),postin];
   fprintf('Reading the file: %s \n',name);
   reduce_post(name,1e-4,'/Volumes/Simone_work/O2_narrowband/vela2/reduced/')
    
end

