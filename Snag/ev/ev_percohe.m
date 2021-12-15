function [cohe,f1,f2]=ev_percohe(evch,selch,dt,n,narm)
%EV_PERCOHE   event periodicity coherence study
%
%   evch       event-channel structure; it can be also a simple double array,
%              with the first set of event times
%   selch      selection array for the channels (0 exclude, 1 first set, 2 second); it can
%              be also a simple double array, with the second set of event times
%   dt         periodicity (days, string for standard physical periodicities,
%              or a 3-array [period phase abscissa]) 
%   n          number of harmonics
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

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


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
    nev1=length(t1);
    t2=selch(:)';
    nev2=length(t2);
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
    t2=t1;
	
	for i = 1:evch.n
        for k = find(selch==1)
            if k == evch.ew.ch(i)
                i1=i1+1;
                t1(i1)=evch.ew.t(i);
            end
        end
        for k = find(selch==2)
            if k == evch.ew.ch(i)
                i2=i2+1;
                t2(i2)=evch.ew.t(i);
            end
        end
	end
	
	nev1=i1;
	t1=t1(1:i1);
    nev2=i2;
	t2=t2(1:i2);
end

f1(1:n)=0;
f2=f1;
cohe=f2;
cohesum=cohe;
per1=per*narm;
if sid == 0
    t1=mod(t1-phas,per1)/per1;
    t2=mod(t2-phas,per1)/per1;
else
%     t1=sid_tim(t1,long)/24;
%     t2=sid_tim(t2,long)/24;
    t1=gmst(t1)/24;
    t2=gmst(t2)/24;
end

for i = 1:n
    f1(i)=sum(exp(-j*mod(i*t1,1)*2*pi))/sqrt(nev1);
    f2(i)=sum(exp(-j*mod(i*t2,1)*2*pi))/sqrt(nev2);
    cohe(i)=abs(f1(i)*f2(i))^2;
    cohemean(i)=abs((f1(i)+f2(i)))^2/2;
end

disp(sprintf(' cohe 1,2,3,4: %f, %f, %f, %f ',cohe(1),cohe(2),cohe(3),cohe(4)));
disp(sprintf(' mean, stdev : %f, %f',mean(cohe),std(cohe)))
figure
plot(1:n,cohe);
hi=histc(cohe,(0:50)*max(cohe)/50);
figure
semilogy((0:50)*max(cohe)/50,hi+0.1),grid on

disp(sprintf(' cohemean 1,2,3,4: %f, %f, %f, %f ',cohemean(1),cohemean(2),cohemean(3),cohemean(4)));
disp(sprintf(' mean, stdev : %f, %f',mean(cohemean),std(cohemean)))
figure
plot(1:n,cohemean);
hi=histc(cohemean,(0:50)*max(cohemean)/50);
figure
semilogy((0:50)*max(cohemean)/50,hi+0.1),grid on

figure
f1_2=abs(f1).^2;
f2_2=abs(f2).^2;
plot(1:n,f1_2),hold on, grid on, zoom on
plot(1:n,f2_2,'r')

x=(0:50)*max(max(f1_2),max(f2_2))/50;
hi=histc(f1_2,x);
figure
semilogy(x,hi+0.1);hold on
hi=histc(f2_2,x);
semilogy(x,hi+0.1,'r')

disp(sprintf(' |f1|^2 1,2,3,4: %f, %f, %f, %f ',f1_2(1),f1_2(2),f1_2(3),f1_2(4)));
disp(sprintf(' mean, stdev : %f, %f',mean(f1_2),std(f1_2)))

disp(sprintf(' |f2|^2 1,2,3,4: %f, %f, %f, %f ',f2_2(1),f2_2(2),f2_2(3),f2_2(4)));
disp(sprintf(' mean, stdev : %f, %f',mean(f2_2),std(f2_2)))