function g=ibar_ant_st_resp
%IBAR_ANT_ST_RESP  interactive call for bar_ant_st_resp
%

% Version 1.0 - July 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2002  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prompt={'Bar lat (degrees)' 'Bar long (degrees)' 'Bar azimuth (from S to W, degrees)' 'Bar inclination (degrees)' ...
      'Source right ascension (degrees)' 'Source declination (degrees)' 'Source epsilon (linear polarization %)' 'Source psi (angle of lin.pol.)' ...
      'Number of sidereal time points'};
default={'42.45','12.7','44','0','266' '-27' '0' '0' '360'};
answ=inputdlg(prompt,'Parameters for sidereal time response of bar antennas',1,default);

bar_ant.lat=eval(answ{1});
bar_ant.long=eval(answ{2});
bar_ant.azim=eval(answ{3});
bar_ant.incl=eval(answ{4});

source.alpha=eval(answ{5});
source.delta=eval(answ{6});
source.eps=eval(answ{7});
source.psi=eval(answ{8});

n=eval(answ{9});

eval('g=bar_ant_st_resp(bar_ant,source,n)');
