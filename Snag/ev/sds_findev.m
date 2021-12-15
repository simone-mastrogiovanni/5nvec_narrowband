function [ew,stmean,stdev,tim]=sds_findev(in,tt)
%SDS_FINDEV  finds events in an sds file sequence
%
%   [ind,len,snr,amp,t,tmax,snr1]=sds_findev(in,tau,deadt,thr)
%
%    in      input sds (the first one) or 0
%    tt      time [init fin] in mjd
%
%    ind     event start (index of the array)
%    len     length (in samples)
%    snr     critical ratio
%    amp     maximum amplitude
%    t       starting time (in case of array, ind-1)
%    tmax    time of the maximum
%    snr1    the total snr array

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

%---------------------- Preamble ---------------------

if ~exist('in','var') || in == 0
    in=selfile(' ');
end

if ~exist('tt','var')
    tt=[0 1.e6];
    iter=1000;
else
    iter=1.e9;
end

[chn,dt,dlen]=sds_selch(in);

lenchunk=round(60/dt)

sds_=sds_open(in);


%--------------------- Initial part ------------------

%pause(1)

answ=inputdlg({'Mode ? (0 no event, 1 find ev. 2 also shape)' ...
    'Statistics ? (0 no stat, 1 AR stat, 2 rectangular stat)' ...
    'tau ? (s)'...
    'CR Threshold ?'...
    'Dead time ?'...
    'Statistics time intervals ?'...
    'Number of frames ?'},...
    'Event finder parameters',1,...
    {'1' '1' '100' '3' '0.1' '10' '100'});

mode(1)=eval(answ{1});
mode(2)=eval(answ{2});
tau=eval(answ{3});
thr=eval(answ{4});
deadt=eval(answ{5});
% mode(8)=eval(answ{6});
% mode(9)=0;
% 
% iter=eval(answ{7});

typ=1;

% frmax=1/(2*dt);
i=0;
zi=0;
len=[];
t=[];
snr=[];
amp=[];
tmax=[];
nev=0;
iter=1.e7;

%--------------------- Iterations ------------------

while 1
   i=i+1;
   [vec,sds_,tim0,holes,n_nan]=vec_from_sds(sds_,chn,lenchunk);
   
   if floor(i/60)*60 == i
       fprintf(' %d  %s \n',i,mjd2s(tim0));
   end
   
   if i > iter
       break
   end
   if tim0 > tt(2) || isempty(vec)
       break
   end
   if tim0 < tt(1)
       continue
   end
   [ind1,len1,snr1,amp1,t1,tmax1,zi]=ar_findev(vec,round(tau/dt),round(deadt/dt),thr,zi);
   stmean(i)=mean(vec);
   stdev(i)=std(vec);
   tim(i)=tim0;
    len=[len len1];
    t=[t tim0+(t1-1)*dt/86400];
    snr=[snr snr1];
    amp=[amp amp1];
    tmax=[tmax tim0+(tmax1-1)*dt/86400];
    nev=nev+length(len1);
    
    if sds_.eof == 2
        break
    end
end

%--------------------- Final part ------------------

ew.nev=nev;
ew.t=t;
ew.tm=tmax;
ew.a=amp;
ew.l=len;
ew.cr=snr;