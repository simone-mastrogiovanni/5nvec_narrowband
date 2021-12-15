function direc=GC()
%
%   Galactic Center
%
%  RA 17h 45m 40.04s, Dec ?29° 00? 28.1? (J2000 epoch)
%  distance 7.4±0.2(stat) ±?0.2(syst) or 7.4±0.3 kpc (?24±1 kly)

direc.name='GC';
direc.a=hour2deg('17:45:40.04');
direc.d=-(29+0/60+28.1/3600);
direc.dist=7.4; % kpc