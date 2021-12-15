function ew=evrog2ew(file)
%EVROG2EW  reads a ROG event file and creates an ew structure
%

if ~exist('file') 
    file=selfile(' ');
end

fid=fopen(file,'r')
canc=double('#');
ii=0;
tline=1;

while 1 > 0
    tline=fgetl(fid);
    ii=ii+1;
    if isnumeric(tline)
        break
    end
%     if tline(1) == canc
    if strcmp(tline(2),'#')
        ii=ii-1;
    else
        
    end
end

nev=ii-1
ii=0;
fid=fopen(file,'r')

ew.nev=nev;
ew.t(1:nev)=0;
ew.tm(1:nev)=0;
ew.ch(1:nev)=0;
ew.a(1:nev)=0;
ew.cr(1:nev)=0;
ew.a2(1:nev)=0;
ew.l(1:nev)=0;
ew.fl(1:nev)=0;
ew.ci(1:nev)=0;

while 1 > 0
    tline=fgetl(fid);
    ii=ii+1;
    if isnumeric(tline)
        break
    end
%     if tline(1) == canc
    if strcmp(tline(2),'#')
        disp(tline)
        ii=ii-1;
    else
        A=sscanf(tline,'%d %d %d %d %d %d %f %f %f %f %d %f %d %d %f %f %f');
        ew.ch(ii)=A(1);
        ew.t(ii)=v2mjd(A(2:7));
        ew.tm(ii)=ew.t(ii)+A(8)/86400;
        ew.a(ii)=A(9);
        ew.cr(ii)=A(10);
        ew.a2(ii)=A(16); % correggere
        ew.l(ii)=A(11); % correggere
        ew.fl(ii)=A(13);
    end
end

% fclose(fid);