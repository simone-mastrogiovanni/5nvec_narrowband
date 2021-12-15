%
% example of remote reading of a FrVector using GPS time and duration
%
% Michele Punturo 13/07/2006
%
% connect remote server 
fd=MatFrvSconnect('farmn11.virgo.infn.it',1490);
% open remote file
ans = MatFrvS_FrIfile(fd,'/virgoData/ffl/lastfile.ffl');
% read TOC of the file
[myVect.nData,myVect.dataQbin]=MatFrvSFileIGetAdcNames(fd);
myVect.dataQ = cellstr(myVect.dataQbin);
clear myVect.dataQbin;
% clear my  Vect.*
% close the file
MatFrvS_FileIEnd(fd);
MatFrvS_close_connection(fd);