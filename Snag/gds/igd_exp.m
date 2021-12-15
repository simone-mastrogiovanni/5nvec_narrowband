function g=igd_exp
%IGD_EXP  interactive exponential signal
%
%   interactive call of gd_sin

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Amplitude' 'Frequency' 'Phase' 'Tau (=0 -> infinite)' ...
      'Length' 'Sampling time'};
defacg1={'1','0.1','0','0','1000','1'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

eval(['g=gd_exp(''amp'',' answ{1} ',''freq'',' answ{2} ',''phase'',' answ{3} ...
      ',''tau'',' answ{4} ',''len'',' answ{5} ',''dt'',' answ{6} ');']);
