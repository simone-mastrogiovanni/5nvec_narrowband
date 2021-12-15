function save_evch(evch)
%SAVE_EVCH  saves an evch structure
%

filfilt={'*.mat','Event/Channel MatLab structure (*.mat)';'*.*','All files'};
[fil,dir]=uiputfile(filfilt,'Save as');
	
fil=strcat(dir,fil);

eval(['save ' fil ' evch']);