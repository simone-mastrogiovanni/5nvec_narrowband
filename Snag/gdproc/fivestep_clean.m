function [gout stat]=fivestep_clean(gin,list_OK,nowin,band,thr,nw,nstat,sim)
% twostep_clean  clean on list and threshold
%
%      [gout stat]=threestep_clean(gin,list_OK,band,thr,nw,out,sim)
%
%   gin       input gd
%   list_OK   (2,n) array with start and stop (typically Science Mode Windows)
%   nowin     (2,n) excluded data (windows of [start stop] exclusions; 0 = no exclusion)
%   band      [minfr maxfr]
%   thr       threshold
%   nw        window (in samples; typically 60)
%   nstat     = 0 choice, otherwise a (0,1) sequence of the length of the rough_nonstat output gd
%   sim       = 1 simulated data (def 0)

% Version 2.0 - October 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

i600=600;

if ~exist('sim','var')
    sim=0;
end

n=n_gd(gin);
dt=dx_gd(gin)/86400;
x=x_gd(gin);
cont=cont_gd(gin);
if isfield(cont,'t0')
    t0=cont.t0;
else
    t0=ini_gd(gin);
end
stat.t0=t0;

y=y_gd(gin);
y=find(y);
stat.tot=n;
stat.ori0=length(y);
   
[i1 i2]=size(list_OK);
if i1 > 1
    y=y_gd(gin);
    k1=1;
    for i = 1:i2
        k2=round((list_OK(1,i)-t0)/dt)-1;
        if k2 > n
            continue
        end
        y(k1:k2)=0;
        k1=round((list_OK(2,i)-t0)/dt)+1;
        if k1 < 1
            k1=1;
        end
    end
    gout=edit_gd(gin,'y',y);
end
   
[i1 i2]=size(nowin);
if i1 > 1
    y=y_gd(gin);
    for i = 1:i2
        k1=round((nowin(1,i)-t0)/dt)-1;
        k2=round((nowin(2,i)-t0)/dt)+1;
        if k1 < 1
            k1=1;
        end
        if k2 > n
            continue
        end
        y(k1:k2)=0;
    end
    gout=edit_gd(gin,'y',y);
end

y=find(y);
stat.list0=length(y);
gin=gout;

if sim == 1
    gin1=gin;
end

gdcell=multi_extr(gin,band);
gin=gdcell{1};

gout=rough_clean(gin,-thr,thr,-nw);
y=y_gd(gout);

i1=length(nstat);

if i1 == 1
    [nstat his xhis]=rough_nonstat(gout,i600,2);
    figure,semilogy(xhis,his),grid on
    ima=max(nstat);
    imi=min(nstat);
    defansw{1}=num2str(imi);
    defansw{2}=num2str(ima);
    answ=inputdlg({'Min permitted value ?','Min permitted value ?'},'Interval selection',2,defansw);
    imi=str2num(defansw{1});
    ima=str2num(defansw{2});
    nstat=y_gd(nstat);
    ii=find(nstat >= imi & nstat <= ima);nstat=nstat*0;
    nstat(ii)=1;
end

i1=1;

for i = 1:length(nstat)
    i2=i600*i+i600/2;
    if nstat(i) == 0
        y(i1:i2)=0;
    end
    i1=i2+1;
end

y(i2+1:length(y))=0;
gout=edit_gd(gout,'y',y);

y=find(y);
stat.thr0=length(y);

if sim == 1
    y=y_gd(gin1);
    i=find(y);
    if isreal(y)
        y(i)=randn(1,length(i))*thr/5;
    else
        y(i)=(randn(1,length(i))+1j*randn(1,length(i)))*thr/8;
    end
    gin=edit_gd(gin,'y',y);
    gdcell=multi_extr(gin,band);
    gin=gdcell{1};
    y=y_gd(gout);
    i=find(y==0);
    y=y_gd(gin);
    y(i)=0;
    gout=edit_gd(gin,'y',y);
end