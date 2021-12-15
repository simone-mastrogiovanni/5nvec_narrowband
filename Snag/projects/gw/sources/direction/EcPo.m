function direc=EcPo(mjd)
%
%   Ecliptical North Pole
%
%  RA 18h 0m 0.0s, Dec +66° 33? 38.55? (J2000 epoch)
%
% eps = 23° 26' 21.45" - 46.815"*T + 0.0006"*T2 + 0.00181"*T^3

if ~exist('mjd','var')
    mjd=51544;
end
T=(mjd-51544)/(100*365.2441);
direc.name='EcPo';
direc.a=270;
% direc.d=66.5607083;
d=90-(23+26/60+21.45/3600-T*46.815/3600-(T.^2)*0.0006/3600+(T.^3)*0.00181/3600);
direc.d=d;
direc.dist=1; % no meaning