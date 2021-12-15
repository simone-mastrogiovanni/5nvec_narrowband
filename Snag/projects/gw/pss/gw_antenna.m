function ant=gw_antenna(pos,azim)
% generic gw antenna
%
%   ant=gw_antenna(pos,azim)
%
%   pos    [long,lat] in deg
%   azim   azimuth (in deg)

% Snag version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ant.name='gw_ant';
ant.long=pos(1);
ant.lat=pos(2);
ant.azim=azim;

ant.incl=0;
ant.height=0;
ant.whour=round(mod(ant.long,360)/15);
ant.shour=ant.whour+1;
ant.type=2;