function [pd,t1,fourp]=ev_period(evch,selch,wind,dt,n,mode,long,narm)
%EV_PERIOD   event periodicity study (phase diagram)
%
%   evch       event-channel structure; it can be also a simple double array,
%              with event times
%   selch      selection array for the channels (0 exclude, 1 include)
%   wind(:,2)  observation window; if 0, from the first to the last event
%   dt         periodicity (days, string for standard physical periodicities,
%              or a 3-array [period phase abscissa]) 
%   n          number of bins
%   mode       = 0  simple events
%              = 1  density normalization; mode(1) = 1, mode(2) = bin width (s)
%              = 2  amplitude; mode(1) = 2, mode(2) = 0,1,2 (normal, abs, square)
%  (long)      longitude (in degrees, for local times)
%  (narm)      harmonics number (1 -> fundamental)
%
%   pd         phase diagram (gd)
%   t1         "phases" of the events
%
%              Standard periodicities (input time mjd)
%
%     type        sign       period        phase     abscissa
%                                        (in days)
%   solar day     sold         1            0           24
%     week        week         7            2            7
%     year        year       365.25        320        365.25
% sidereal day    sidd   0.9972695667   0.1548908       24   ! computed in non-linear way
%   moon day      mond   1.035050101        ?           24
%  moon month     monm        28            ?
%
%   on Saturday 01-Jan-2000 00:00 
%      - mjd is 51544
%      - Greenwich sidereal hour is 6.6645
%      - local (Rome, long -12.5) sidereal hour is 7.4979

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


if ~exist('long')
    long=0;
end

if ~exist('narm')
    narm=1;
end

per=1;phas=0;absc=360;sid=0;

if isnumeric(dt)
    if length(dt) == 3
        per=dt(1);phas=dt(2);absc=dt(3);
    else
        per=dt(1);
    end
else
    switch lower(dt)
        case 'sold'
            per=1;
            phas=0;
            absc=24;
        case 'week'
            per=7;
            phas=4;
            absc=7;
        case 'year'
            per=365.25;
            phas=0;
            absc=12;
        case 'sidd'
            per=0.9972695667;
            phas=0.1548908;
            absc=24;
            if narm == 1
                sid=1;
            end
        case 'mond'
            per=1.035050101;
            phas=0;
            absc=24;
        case 'monm'
            per=28;
            phas=0;
            absc=per;
    end
end

i1=0;i2=0;
evchstr=0;

if isnumeric(evch)
    t1=evch(:)';
    nev=length(t1);
else
    evchstr=1;
    ewyes=0;
	if isfield(evch,'ew')
        ewyes=1;
	else
        evch.ew=ev2ew(evch.ev);
	end

	nchtot=length(evch.ch.an);
	t1(1:evch.n)=0;
	
	for i = 1:evch.n
        for k = find(selch==1)
            if k == evch.ew.ch(i)
                i1=i1+1;
                t1(i1)=evch.ew.t(i);
            end
        end
	end
	
	nev=i1;
	t1=t1(1:i1);
end

if length(wind) > 1
    t1=wind_sel(t1,wind);
    nev=length(t1);
else
    wind(1,1)=min(t1);
    wind(2,1)=max(t1);
end

nev

switch mode(1)
    case 1
        if length(mode) == 2
            bin=mode(2);
        else
            bin=3600;
        end
        dens=ev_dens(t1,1,bin);
        ini=ini_gd(dens);
        dx=dx_gd(dens);
        dens=y_gd(dens); 
        ii=find(dens>0);avedens=mean(dens(ii));
        ii=find(dens==0);dens(ii)=avedens;
        a=avedens./dens(floor((t1-ini)/dx)+1);a=a';
    case 2
        if length(mode) == 1
            mode(2)=1;
        end
        if evchstr == 0
            disp('mode 2 not correct')
            a=t1*0+1;
        else
            switch mode(2)
                case 0
                    a=evch.ew.a;
                case 1
                    a=abs(evch.ew.a);
                case 2
                    a=evch.ew.a.^2;
            end
        end
end

t=t1;
fourp(1:10)=0;
per1=per*narm;
if sid == 0
    t1=mod(t1-phas,per1)*absc/per1;
else
    %t1=sid_tim(t1,long);
    t1=gmst(t1);
end
%per,absc,min(t1),max(t1)
for i = 1:10
    fourp(i)=sum(exp(-j*mod(i*t/per1,1)*2*pi))/sqrt(nev);
end

x=(0:(n-1))*absc/n;
hi0=hist(t1,x+0.5*absc/n);

if mode(1) == 0
    hi=hi0;
else
    hi=x*0;
    ii=floor(t1*n/absc)+1;
    for i = 1:n
        hi(i)=sum(a(find(ii==i)));
    end
end

sumhi=sum(hi)

figure
x1=(0:n)*absc/n;
hi(n+1)=hi(n);
stairs(x1,hi);zoom on, grid on

pd=gd(hi);
pd=edit_gd(pd,'capt','Phase diagram','x',x,'type',2);

figure
plot(t-floor(t(1)),t1,'+'),grid on

me=sum(hi)/n
me0=sum(hi0)/n;
A=me/me0;
hi1=find(hi0(1:n)>10);
hi1=hi(hi1);
nhi=length(hi1);

if nhi > 0
    chi2=((hi1-me).^2)./(hi1*A);
    chi2=sum(chi2);
    pr=1-chi2cdf(chi2,nhi);
    str=sprintf(' -> Chi Square (with %d d.o.f.) = %g  \n    -- overcoming probability %g',...
        nhi,chi2,pr);
    disp(str)
end