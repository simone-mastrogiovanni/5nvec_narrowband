wavefile='/Volumes/Simone_work/O2_narrowband/vela2/injections_L.mat'; % Insert here the wave file
filename='/Volumes/Simone_work/O2_narrowband/vela2/composed_file_L.mat'; % Insert here the name of file with the maximum over freq and sd
uppercount=100; % insert the number of injected waves
H0norm=1e-6; % Insert the injected amplitude
H0in=1e-6; % Insert the initial amplitude to simulate
Hstep=1e-8; % Insert the amplitude step
fileA='/Volumes/Simone_work/O2_narrowband/vela2/L/sdindex/22.3505_22.3953_J0835m4510_days_57758-57990_templates.mat'; % insert the deca-vector template file
prefilesd='/Volumes/Simone_work/O2_narrowband/vela2/L/sdindex/J0835m4510_J0835m4510_days_57758-57990data_part2_sd_index='; % Insert the first part of the real analysis file
postfilesd='.mat'; % Insert the second part of the real analysis file
prefile='/Volumes/Simone_work/O2_narrowband/vela2/reduced/reduced_inj_'; % Insert the first part of the injected analysis file
postfile='_J0835m4510_days_57758-57990data_part2_sd_index=0.mat'; % Insert the second part of the injected analysis file
dt=1; % Down-sampling time
perc=0.95; % Percentage of the upper-limit
[upperH0,real_fra]=upper_limit_final_form(wavefile,filename,uppercount,H0in,Hstep,fileA,prefile,postfile,prefilesd,postfilesd,dt,perc,Sthr)

% RICORDATI DI CAMBIARE S_thr