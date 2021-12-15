% search_10Hz_peaks_with_ef 10 Hz peak search with epoch folding

g1=sds2gd_selind('VIR_hrec50Hz_20050915_043340_.sds',1,2*4194304+1,3*4194304)
% g1=sds2gd_selind('VIR_hrec4kH_20070113_195633_.sds',1,2*4194304+1,3*4194304)

g2=gd_wiener_hp(g1,16384,1,200,1200)

gout=gd_epochfold(g2,3*0.10000025)