%uisetgdgw  sets gds

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listftsgd={'Gravitational Pulse' 'Chirp' 'Antenna spectrum' 'Bar antenna sid.t. response'};
listftsgd1={'igd_drawspect'};
  
  [seldelgd1,sdgok]=listdlg('PromptString','Which gw function to set ?',...
   'Name','Gravitational signals',...
   'ListSize',[200 70],...
   'SelectionMode','single',...
   'ListString',listftsgd);

switch seldelgd1
case 1
   eval([answnamwgd{1} '=igw_pulse']);
case 2
   eval([answnamwgd{1} '=igd_chirp']);
case 3
   eval([answnamwgd{1} '=igd_drawspect']);
case 4
   eval([answnamwgd{1} '=ibar_ant_st_resp']);
end
