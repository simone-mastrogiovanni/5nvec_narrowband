function sour=scorpiusx1(t,label)
% Scorpius X-1  source parameters
% 
%   t    mjd or year
%
%  rp=gw_radpat(virgo,scorpiusx1,51000:0.01:51001);
%  f=lin_radpat_interf(scorpiusx1,virgo,0:0.1:24*100);

sour.name='scorpiusx1';
sour.a=hour2deg('16:19:55.07');
sour.d=-15.64022;
sour.a=4.275*180/pi;
sour.d=-0.250*180/pi;
sour.pepoch=51544;

sour.v_a=0; % marcs/y
sour.v_d=0;   % marcs/y
            
sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eta=0;
sour.psi=0;
sour.eps=0;
sour.coord=0;