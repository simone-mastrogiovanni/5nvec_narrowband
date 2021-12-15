function tcb=tdt2tcb(mjd)
% TDT2TCB: function to compute transformation from TT to TCB
% (from TEMPO2 program. Now we have the same trasformation used by Matt.)
% See also http://en.wikipedia.org/wiki/Time_standard

gps=mjd2gps(mjd);
tcb=((44244+(gps+51.184)./86400-43144.0003725)*1.55051979176e-8)*86400;
