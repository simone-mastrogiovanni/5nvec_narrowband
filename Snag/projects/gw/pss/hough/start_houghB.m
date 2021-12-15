% start_houghB  driver for hough.m

disp('---------------------------------------')

start_pss_sim_pm_lrB

ppar=pss_par('init');
% ppar.hmap.type=0;

disp(' ---> Source 1')

ppar.band.f0=sour(1).f0; disp(sour(1).f0)

HM1=hough(ppar,pm);

disp(' ---> Source 2')

ppar.band.f0=sour(2).f0; disp(sour(2).f0)

HM2=hough(ppar,pm); 

