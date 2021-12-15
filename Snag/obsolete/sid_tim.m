function tsid=sid_tim(mjd,long)
%SID_TIM  sidereal time (in hours)
% 
%    mjd        modified julian date (days)
%    long       longitude (positive if west of Grenwich; degrees)
%
% Da' un errore dell'ordine del minuto. See also GMST function

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

T=(mjd-51544.5)/36525; % centuries
tsid0=24110.54841+T.*(8640184.812866+T.*(0.093104-6.2e-6*T));
ut=(mjd-floor(mjd))*86400;
tsid=tsid0+1.00273790935*ut;
tsid=tsid/3600-long/15;
tsid=mod(tsid,24);
if tsid < 0
    tsid=tsid+24;
end