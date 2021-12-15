% crea_lintfmap  driver of crea_linpm

par.nt=500;
par.nfr=1000;
par.dt=1;
par.dfr=0.1;
par.thresh=4;

lines(1).fr=30;
lines(1).d=0;
lines(1).amp=4;

tfmap=crea_linpm(lines,par)