% template m file do_base_run_sp
%

% cd the correct folder

g1=sds2gd_selind('VIR_hrec_20050802_001627_.sds',1,1,1000000) % create gd with selected data

% with snag interface
% do a power spectrum with 20 pieces, resolution 4 and put in sp6

h6=sp2hdens(sp6)

% with snag interface
% do figures of h6

sds_writegd('','h_dens_6.sds',h6)

