% search_10Hz_peaks_with_ef1 10 Hz peak search with epoch folding

g1=sds2gd_selind('VIR_hrec50Hz_20050915_043340_.sds',1,0*4194304+1,1*4194304)

g2=gd_wiener(g1,16384,1,4,0.02)

gout=gd_epochfold(g2,3*0.10000025)