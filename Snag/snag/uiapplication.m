%uiapplication  some demos

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listdemo={'Data Browser (with simulation)' 'GW events' ...
      'GW_SIM (fine antenna simulation)' ' ' ...
      'PSS - periodic source search' ...
   	'TFFF - time-frequency frequency filters'};
listdemo1={'data_browser' 'gw_events' 'gw_sim' ' ' ...
      'pss_explorer' 'tfff_explorer'};
  
  [whichdemo,sdgok]=listdlg('PromptString','Which application ?',...
   'Name','Application choice',...
   'ListSize',[220 180],...
   'SelectionMode','single',...
   'ListString',listdemo);

if whichdemo < 4
   eval(listdemo1{whichdemo});
elseif whichdemo > 4
   eval(listdemo1{whichdemo},['msgbox('...
         '''Snag external application not present'','...
         '''External application launch'','...
         '''error'')']);
end

   
