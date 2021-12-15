%uisetgd  sets gds

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listftsgd={'Sinusoid' 'Saw-tooth or priodic f' 'Exponential' 'Polinomial' 'Ramp' 'Deltas' 'Pdf'};
listftsgd1={'igd_sin' 'igd_sawtooth' 'igd_exp' 'igd_pol' 'igd_ramp' 'igd_delt' 'igd_pdf'};
  
[seldelgd1,sdgok]=listdlg('PromptString','Which function to set ?',...
   'Name','Deterministic signals',...
   'ListSize',[250 150],...
   'SelectionMode','single',...
   'ListString',listftsgd);

eval([answnamwgd{1} '=' listftsgd1{seldelgd1}])
