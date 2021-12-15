%
% example of remote reading of a FrVector using GPS time and duration
% and FFT
%
% Michele Punturo 14/07/2006
%
% connect remore server 
fd=MatFrvSconnect('farmn11.virgo.infn.it',1490);
% open remote file
ans0 = MatFrvS_FrIfile(fd,'/virgoData/ffl/C5/rawdata.ffl');
% read GPS start time of the file
GPSstart=MatFrSFileITStart(fd);
GPSstart=GPSstart+86400;

%
Nseconds = 30;
[myVect.nData,myVect.dx,myVect.DataD]=MatFrvSFileIGetV(fd,'Pr_B1_ACp',GPSstart,Nseconds);
GTimeEnd=GPSstart+Nseconds-myVect.dx;
t=GPSstart:myVect.dx:GTimeEnd;
subplot(2,1,1)
plot(t,myVect.DataD);
xlabel('GPS time (s)')
%
Y=fft(myVect.DataD, myVect.nData);
Pyy = Y.* conj(Y) / myVect.nData;
f=(0:(myVect.nData-1)/2)/myVect.nData/myVect.dx;
subplot(2,1,2)
loglog(f,Pyy(1:(myVect.nData/2)));
xlabel('frequency (Hz)')
GPSstart1=GPSstart; size(t)
    figure

for iii = 1:10
    GPSstart1=GPSstart1+Nseconds/4;
    [myVect.nData,myVect.dx,myVect.DataD]=MatFrvSFileIGetV(fd,'Pr_B1_ACp',GPSstart1,Nseconds);
    GTimeEnd=GPSstart1+Nseconds-myVect.dx;
    t=GPSstart1:myVect.dx:GTimeEnd;size(t)
    subplot(2,1,1)
    plot(t,myVect.DataD);
    xlabel('GPS time (s)')
    %
    Y=fft(myVect.DataD, myVect.nData);
    Pyy = Y.* conj(Y) / myVect.nData;
    f=(0:(myVect.nData-1)/2)/myVect.nData/myVect.dx;
    subplot(2,1,2)
    loglog(f,Pyy(1:(myVect.nData/2)));
    xlabel('frequency (Hz)')
    pause(0.1)
end
% clear myVect.*
%
% close the file
MatFrvS_FileIEnd(fd);
MatFrvS_close_connection(fd);


