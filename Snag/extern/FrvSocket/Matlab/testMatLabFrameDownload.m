%
% example of remote reading of a FrVector Frame by Frame
%
% Michele Punturo 13/07/2006
%
% connect remore server 
fd=MatFrvSconnect('farmn11.virgo.infn.it',1490);
%
% open remote file
ans = MatFrvS_FrIfile(fd,'/virgoData/ffl/raw.ffl');
% load in the Server memory the frame
ans=MatFrvSIncrFrame(fd);
% download the frame info
[Fr.experiment,Fr.run,Fr.frame,Fr.dataQuality,Fr.GTimeS,Fr.GTimeN,Fr.ULeapS,Fr.dt]=MatFrvSFrameInfoDownload(fd);
%
GTimeStart=Fr.GTimeS;
i=4;
while (ans>0 & i>0)
 % download the FrVector
 [myVect.nData,myVect.dx,myVect.DataD]=MatFrvSGetVect(fd,'Pr_B1_ACp');
 GTimeEnd=GTimeStart+Fr.dt-myVect.dx;
 %t=GTimeStart:(myVect.dx):GTimeEnd;
 GTimeStart=GTimeEnd;
 subplot(2,2,4-i+1)
 plot(myVect.DataD);
 % next Frame
 ans=MatFrvSIncrFrame(fd);
 clear myVect.*
 i=i-1;
end
%
% close remote file
MatFrvS_FileIEnd(fd);
% close TCP connection
MatFrvS_close_connection(fd);


