% driver_pmf

band=[101 102]; % EDIT
VSR='VSR4'; % EDIT

eval(['[gA tim vel]=read_peakmap(''list_' VSR '_pmcl.txt'',''center'',band,0,0);'])

[A cont]=gd2_to_peaks(gA);

[pmf t f]=pmf_from_peaks(A,1,2);