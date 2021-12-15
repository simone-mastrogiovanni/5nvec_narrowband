function g=igw_pulse
%IGW_PULSE: interactive pulse waveforms plot
%
%		interactive call of gw_pulse
%

% Version 1.0 - June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%							 Cristiano Palomba - cristiano.palomba@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prompt={'Type (? if you don''t know)' 'Sampling Time (s)' 'Mass (solar masses)' ...
      'Distance (Mpc)' 'Particle Mass (solar masses)'};
default={'?','1e-6','1.5','15','0.001'};
answ=inputdlg(prompt,'Parameters for pulse waveforms',1,default);
eval(['g=gw_pulse(''opt'',' 'answ{1}' ',''st'',' answ{2} ',''mass'',' answ{3} ...
      ',''dist'',' answ{4} ',''mpart'',' answ{5} ',''show'')']);
