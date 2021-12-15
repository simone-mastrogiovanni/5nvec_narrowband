uifilfilt={'*.mat','Event/Channel MatLab structure (*.mat)';'*.*','All files'};
[uifil,uidir]=uigetfile(uifilfilt,'Save as');
	
uifil=strcat(uidir,uifil);

eval(['load ' uifil ' -mat']);