function [gdm w]=model_sidasid(ant,sid,asid)
% model_sidasid   signal reconstruction from sid-antisid amplitude and phase
%                 one year, (2010)
%
%   ant    antenna structure
%   sid    sidereal periodicity [amp phase] (phase in hours)
%   asid   anti-sidereal periodicity [amp phase] (phase in hours)

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

t=v2mjd(2010)+(0:1/24:365);

long=ant.long;

tsid=mod(gmst(t)+long/15,24);
tasid=mod(agmst(t)+long/15,24);

gdm=sid(1)*cos((tsid-sid(2))*pi/12)+asid(1)*cos((tasid-asid(2))*pi/12);

figure,plot(t-t(1),gdm),grid on,xlabel('doy')

gdm=gd(gdm);
gdm=edit_gd(gdm,'dx',1/24);

w=gd_worm(gdm,'icshow');