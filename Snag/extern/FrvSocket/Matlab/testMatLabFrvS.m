%
% example of remote reading of a FrVector using GPS time and duration
%
% Michele Punturo 13/07/2006
%
% connect remote server 
fd=MatFrvSconnect('farmn11.virgo.infn.it',1490);
% open remote file
ans = MatFrvS_FrIfile(fd,'/virgoData/ffl/lastfile.ffl');
% read GPS start time of the file
GPSstart=MatFrSFileITStart(fd);
GPSstart=GPSstart+1;
% read GPS end time of the file 
GPSend=MatFrSFileITEnd(fd);
%
Nseconds = 10
DT=0;
Nplots=4
Nplx=(sqrt(Nplots));
Nply=Nplots/Nplx;
%
i=Nplots;
while (i>0)
% read "Nseconds" seconds of data 
 if (GPSstart < GPSend-Nseconds) 
     t1=clock;
  [myVect.nData,myVect.dx,myVect.DataD]=MatFrvSFileIGetV(fd,'Pr_B1p_ACp',GPSstart,Nseconds);
     t2=etime(clock,t1);
     DT=DT+t2;
 end
 GTimeEnd=GPSstart+Nseconds-myVect.dx;
 t=GPSstart:myVect.dx:GTimeEnd;
 GPSstart=GTimeEnd+myVect.dx
 subplot(Nplx,Nply,(Nplots-i+1))
 plot(myVect.DataD);
 clear myVect.*
 i=i-1;
end
%
% close the file
MatFrvS_FileIEnd(fd);
MatFrvS_close_connection(fd);
DT/Nplots %Mean transfer time