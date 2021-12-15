%deletegd  deletes gds

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listgd;
nlsdgd=gdol.n
nlsdgd1=length(gdol.name);

for i = nlsdgd+1,nlsdgd1
   gdol.name{i}=' ';
end
liststringdgd=gdol.name;
  
  [seldelgd,sdgok]=listdlg('PromptString','Which gd to delete ?',...
   'Name','Delete gd',...
   'SelectionMode','multiple',...
   'ListString',liststringdgd);

numdelgd=length(seldelgd);

for i = 1:numdelgd
   eval(['clear ',liststringdgd{seldelgd(i)},';']);
end

