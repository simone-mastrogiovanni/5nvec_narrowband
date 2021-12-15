function sour=sn1987a()
% Date 23 Feb 1987 UTC 23:00
% Right ascension	05h 35m 28.03s
% Declination	?69° 16? 11.79?
% Epoch	J2000
% Galactic coordinates	G279.7-31.9
% Distance	51.4 kpc (168,000 ly)[4]
% Host	Large Magellanic Cloud
% Progenitor	Sanduleak -69 202

% % Ascensione retta	05h 35m 49.942s
% % Declinazione	?69° 17? 57.60?

sour.name='sn1987a';
sour.a=83.866791666666657; % (5+35/60+28.03/3600)*15; 
sour.d=-69.269913888888894; % -(69+16/60+11.69/3600);
sour.v_a=0.0; % marcs/y
sour.v_d=0.0;   % marcs/y
sour.pepoch=5.463200000022558e+04;
sour.f0=36.0625 ;
sour.df0=0;
sour.ddf0=0;
sour.fepoch=58389;

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eta=0; 
sour.iota=0;
sour.siota=0;
sour.psi=0;
sour.spsi=0;
sour.h=1;
sour.snr=1;
sour.coord=0;
sour.chphase=0;
