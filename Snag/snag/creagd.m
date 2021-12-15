% creagd  interactive gd creation from a double array

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg={'Input double array (for the gd "y")' 'Sampling "time"' 'Init' ...
      'Type (1 - virtual abscissa, i.e. equispaced data;  2 - real abscissa)',...
      'Caption'};
defacg={'y' '1' '0' '1' 'default gd'};
answcg=inputdlg(promptcg,'Creation of a gd from a double array',1,defacg);

if exist(answcg{1}) == 0
   msgbox([answcg{1} ': not existing double array']);
else
   eval(strcat(answnamwgd{1},'=gd(',answcg{1},');'));
   eval(strcat(answnamwgd{1},'=edit_gd(',answnamwgd{1},',''dx'',',answcg{2},...
      ',''ini'',',answcg{3},',''type'',',answcg{4},',''capt'',''',answcg{5},''')'))
end
