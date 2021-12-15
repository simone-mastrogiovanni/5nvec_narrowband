addpath('/storage/users/simone/commented_programs/');
addpath('/storage/users/simone/Work_tesi/f_compiled/pss2/');
selpath='/storage/users/simone/ligoh_O1_cal/J2229_6114/sdindex/'; % Insert the path where you are working
timepath='/storage/users/simone/ligoh_O1_cal/J2229_6114/J2229H_J2229-6114_timevar.mat'; % insert the path with the mat file containing timing vectors
inmat='/storage/users/simone/ligoh_O1_cal/J2229_6114/J2229H_J2229-6114data_part1.mat'; % insert the path of the mat file containing doppler corrected series
inseg='/storage/users/simone/O1_H1_segments_science_full.txt'; % Path to science segment list
second time=num2str(0); % Isert a new reference time
cut_arr=num2str([0 0]); % Insert data to extract in MJD
reduce_pss_band_recos_strob8ph_part2(selpath,timepath,'JH_',inmat,inseg,num2str(38.715313659746649),num2str(0.0774),num2str(-7),num2str(7),cut_arr,num2str(0),num2str(0));
