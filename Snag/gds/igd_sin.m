function g=igd_sin
%IGD_SIN  interactive sinusoidal signal
%
%   interactive call of gd_sin

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Amplitude' 'Frequency' 'Phase' 'Length' 'Sampling time'};
defacg1={'1','0.1','0','1000','1'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

eval(['g=gd_sin(''amp'',' answ{1} ',''freq'',' answ{2} ',''phase'',' answ{3} ...
      ',''len'',' answ{4} ',''dt'',' answ{5} ');']);
