function g=igd_chirp
%IGD_CHIRP  interactive access to gd_chirp
%
%         g=igd_chirp

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prompt={'Sampling time'...
      'Chirp mass'...
      'Minimum frequency'...
      'Maximum frequency'...
      'Coalescence time (s)'...
      'Length'...
      'Amplitude (if 0, computes the amp at 100 Mpc)'};
default={'0.0001','0','100','1000','2.5','32768','1'};

answ=inputdlg(prompt,'Parameters of the pulse',1,default);

eval(['g=gd_chirp(''dt'',' answ{1}...
      ',''masc'',' answ{2}...
      ',''fmin'',' answ{3}...
      ',''fmax'',' answ{4}...
      ',''ct'',' answ{5}...
      ',''len'',' answ{6}...
      ',''amp'',' answ{7} ')']);