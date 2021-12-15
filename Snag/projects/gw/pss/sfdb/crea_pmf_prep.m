% crea_pmf_prep

Dfr=5;
VSR='VSR2'; % EDIT
dfr=0.005;  % EDIT

for i = 26:26
    band=[(i-1) i]*Dfr;
    strtit=sprintf(' %s  band %4.1f - %4.1f',VSR,band)
    savestr=sprintf('pmf_prep_%s_%03d_%03d',VSR,band);
    savestrnp=sprintf('np_%s_%03d_%03d',VSR,band);
    savestrsp=sprintf('sp_%s_%03d_%03d',VSR,band);
%     eval(['[gA tim vel]=read_peakmap(''list_' VSR '_pmcl.txt'',''center'',band,0,0);'])
    eval(['[gA tim vel]=read_peakmap_2016(''list_' VSR '_pmcl.txt'',band,0);'])  %% MANCA RUNSTR !
    band=[band dfr];
%     eval(['[' savestrnp ',' savestrsp ',t,f]=pmf_prepare(gA,band);'])
%     eval(['save(''' savestr ''',''' savestrnp ''',''' savestrsp ''',''t'',''f'');'])
    [np,sp,t,f]=pmf_prepare(gA,band);
    eval(['save(''' savestr ''',''np'',''sp'',''t'',''f'');'])
end