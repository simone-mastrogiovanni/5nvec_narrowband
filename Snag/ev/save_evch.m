function save_evch(evch)
%SAVE_EVCH  saves an evch structure
%

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

filfilt={'*.evch.mat','Event/Channel MatLab structure (*.evch.mat)';'*.*','All files'};
[fil,dir]=uiputfile(filfilt,'Save as');
	
fil=strcat(dir,fil);

eval(['save ' fil ' evch']);