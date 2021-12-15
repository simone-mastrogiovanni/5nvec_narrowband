function m=ddst2mp(file,t)
%dds2MP  creates an mp with the data of an dds t-type file
%
%   file        input file
%   t           [init dur nmean] initial time, duration (in dds units) and mean every
%
%  If the arguments are not present, asks interactively.
%
% The abscissa is in hours, starting from the midnight before

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file')
    file=selfile(' ');
end

dds_=dds_open(file);

t0=dds_.t0;
dt=dds_.dt;
n=dds_.len;
t00=datenum([1980 1 6 0 0 0]);
strt0=datestr(t0/86400+t00);
ttot=floor(dds_.len*dds_.dt);
strdur=int2str(ttot);
strm=int2str(ceil(dds_.len/10000));

if ~exist('t')
    answ=inputdlg({'Starting time of wanted data','Duration (s)','Mean every'}, ...
        'Time data selection',1,{strt0,strdur,strm});
    t(1)=(datenum(answ{1})-t00)*86400;
    t(2)=eval(answ{2});
    t(3)=eval(answ{3});
end

minind=round((t(1)-t0)/dt+1);
numdat=round(t(2)/dt);

ft0=floor(t(1)/86400)*86400;
t0=(t(1)-ft0)/3600;
m.x=t0;
m.dx=dds_.dt*t(3)/3600;
m.nch=dds_.nch-1;

for i = 1:dds_.nch-1
    m.ch(i).name=dds_.ch{i+1};
end

del=dds_.point0+(dds_.nch*(minind-1))*8;
status=fseek(dds_.fid,del,'bof');numdat

A=fread(dds_.fid,[dds_.nch,numdat],'double');
if t(3) > 1
    A=mean_every(A,2,t(3));
end
m.x=A(1,:)-floor(A(1,1));
for i = 1:dds_.nch-1
    m.ch(i).y=A(i+1,:);
end
