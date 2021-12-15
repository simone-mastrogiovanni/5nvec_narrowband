% search_10Hz_peaks_with_comb_ef 10 Hz peak search with epoch folding

% g1=sds2gd_selind('VIR_hrec50Hz_20050915_043340_.sds',1,0*4194304+1,1*4194304)
g1=sds2gd_selind('VIR_hrec4kH_20070113_195633_.sds',1,0*4194304+1,1*4194304)

yi=comb_10hz(g1)

gout=gd_epochfold(yi,3*0.10000025)