% ana_peakmap_basic_cl

Dfr=5;
VSR='VSR4'; % EDIT

for i = 17:26
    band=[(i-1) i]*Dfr;
    strtit=sprintf(' %s  band %4.1f - %4.1f',VSR,band)
    savestr=sprintf('PMH_%s_%03d_%03d_cl',VSR,band);
    eval(['[A tim vel]=read_peakmap0(''list_' VSR '_pmcl.txt'',band,0,0);'])
    eval(['[x y v ' savestr ']=plot_peaks(A,1,0,1,strtit);'])
    eval(['save(''' savestr ''',''' savestr ''');'])
end