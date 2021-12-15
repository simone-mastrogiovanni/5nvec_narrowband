% start_hough  driver for hough.m

%load pm1.mat pm -mat  % comment if pm exists

ppar=pss_par('init');

ppar.band.f0=sour(1).f0

HM1=hough(ppar,pm);

ppar.band.f0=sour(2).f0

HM2=hough(ppar,pm);

