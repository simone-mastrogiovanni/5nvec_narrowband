function ew=evrogcoin2ew(file)
%EVROG2EW  reads a ROG event file and creates an ew structure
%
% 1-3    icoin,time1,time2,
% 4-10   year,day2001,month,day,hour,min,sec,
% 11-13  time1-time2 sec,amp1,amp2,
% 14-16  tss_greenw,tss_local1,modbar1 from GC,
% 17-20  snr1,snr2,icheck(1 ok),energia_check 

if ~exist('file') 
    file=selfile(' ');
end

fid=fopen(file,'r')
ii=0;
tline=1;

while 1 > 0
    tline=fgetl(fid);
    ii=ii+1;
    if isnumeric(tline)
        break
    end
end

nev=ii-3
nev=nev*2;
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
tline=fgetl(fid);
tline=fgetl(fid);

while 1 > 0
    tline=fgetl(fid);
    if isnumeric(tline)
        break
    end
    jj=2*ii+1;
    ii=ii+1;
    A=sscanf(tline,'%d %f %f %d %d %d %d %d %d %f %f %f %f %f %f %f %f %f %d %f');
    ew.ch(jj)=1;
    ew.t(jj)=A(2);
    ew.tm(jj)=A(2);
    ew.a(jj)=A(12);
    ew.cr(jj)=A(17);
    ew.fl(jj)=A(19);
    ew.ch(jj+1)=2;
    ew.t(jj+1)=A(3);
    ew.tm(jj+1)=A(3);
    ew.a(jj+1)=A(13);
    ew.cr(jj+1)=A(18);
    ew.fl(jj+1)=A(19);
end

% fclose(fid);