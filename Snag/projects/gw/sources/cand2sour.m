function sour=cand2sour(cand,epoch)

sour.ecl=[cand(2) cand(3)];
sour.lam=cand(2);
sour.bet=cand(3);
sour.f0=cand(1);
sour.df0=cand(4);
sour.ddf0=0;
sour.fepoch=epoch;
sour.pepoch=epoch;
sour.v_a=0;
sour.v_d=0;
[sour.a,sour.d]=astro_coord('ecl','equ',cand(2),cand(3));
sour.ulam=cand(7);
sour.ubet=cand(8);