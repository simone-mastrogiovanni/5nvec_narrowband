function sour=crea_psscand(a,d,equecl,f0,df0,fepoch)
% creates cw candidate
%
%  a,d       right asc and declination (or ecliptical coordinates)
%  equecl    =0 r.a./dec   =1 lambda/beta

sour.name='candidate source';

if equecl == 1
    l=a;b=d;
    [a,d]=astro_coord('ecl','equ',a,d);
else
    [l,b]=astro_coord('equ','ecl',a,d);
end

sour.a=a;
sour.d=d;
sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=fepoch;
sour.f0=f0;
sour.df0=df0;
sour.ddf0=0;
sour.fepoch=fepoch;
sour.ecl=[l b];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=0;
sour.psi=0;
sour.h=1;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;