%newgdgui   to create new gd

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg='Name of the new gd';
defacg={'g'};
answnamwgd=inputdlg(promptcg,'New gd',1,defacg);

listcrnewgd={'Create a gd from a double array' ' ' ...
      'Create a gd from SNF file'...
      'Create a gd from a simple ASCII file' ' ' ...
      'Deterministic signals' 'Stochastic signals' 'GW signals'};

selnewgdgui=2;

while selnewgdgui == 2 | selnewgdgui == 5
   selnewgdgui=listdlg('PromptString','Creating a new gd',...
      'Name','New gd',...
   	'ListSize',[250 200],...
   	'SelectionMode','single',...
      'ListString',listcrnewgd);
end

switch selnewgdgui
case 1
   creagd;
case 3
   uiinputfile;
case 4
   uiinputascii;
case 6
   uisetgd;
case 7
   uisetgdnoise;
case 8
   uisetgdgw;
end


