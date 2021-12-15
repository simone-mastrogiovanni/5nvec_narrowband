tempH='/Volumes/Simone_work/O2_narrowband/vela2/H/sdindex/22.3505_22.3953_J0835m4510_days_57758-57990_templates.mat';
tempL='/Volumes/Simone_work/O2_narrowband/vela2/L/sdindex/22.3505_22.3953_J0835m4510_days_57758-57990_templates.mat'; %Insert here the Livingstone templates file
preH='/Volumes/Simone_work/O2_narrowband/vela2/H/sdindex/J0835m4510_J0835m4510_days_57758-57990data_part2_sd_index='; %Insert here the first part of H file
postH='.mat'; %Insert here the part part of H file
preL='/Volumes/Simone_work/O2_narrowband/vela2/L/sdindex/J0835m4510_J0835m4510_days_57758-57990data_part2_sd_index='; %Insert here the first part of L file
postL='.mat'; %%Insert here the first part of L file
path
for i=-17:1:17
   inmatH=[preH,num2str(i),postH]
   inmatL=[preL,num2str(i),postL]
   path_name=['/Volumes/Simone_work/O2_narrowband/vela2/J0835m4510_',num2str(i),'_']
   deca_vector(inmatH,inmatL,tempH,tempL,path_name);   
end

