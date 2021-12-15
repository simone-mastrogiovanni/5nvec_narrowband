%GD2_PLOT   plots gd2

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


listgd2
gdsscra=gdol2.name

[seldelgd2,sdgok]=listdlg('PromptString','Which gd2 to map ?',...
   'SelectionMode','single',...
   'ListString',gdsscra);

% eval(['map_gd2(' gdsscra{seldelgd2} ');']);
eval(['image_gd2(' gdsscra{seldelgd2} ');']);
