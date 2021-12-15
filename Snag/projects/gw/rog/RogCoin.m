%------- LEGGE GLI EVENTI E CREA LE STRUTTURE -----------------------------------------

crea_rog_ew_coin

%-------- ANALIZZA LA PERIODICITA' SIDERALE ----------------------------------------

[pd,t1,fourp]=ev_period(t,[1 1],0,'sidd',24,0,0);

% function [pd,t1,fourp]=ev_period(evch,selch,wind,dt,n,mode,long,narm)
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
%  (narm)      harmonics number (1 -> fu
%
%   pd         phase diagram (gd)
%   t1         "phases" of the events

%-------- CALCOLA L'ANDAMENTO DELLE COINCIDENZE ASPETTATE NEL TSID----------------------------------------

rogdirez04

%-------- CALCOLA LO SPETTRO IMPULSIVO ----------------------------------------

sp2=ev_spec(t,[0 1],0,0,4,30);

% function sp=ev_spec(evch,selev,wind,minfr,maxfr,res)
%EV_SPEC  event spectrum
%
%   evch      event/channel structure or just a double array with event times
%   selev     event selection array (0 excluded channel)
%   wind(:,2) observation window; if 0, from the first to the last event
%   minfr     minimum frequency
%   maxfr     maximum frequency
%   res       resolution

%-------- Calcola il Filtro Adattato Impulsivo -----------------------------

[spet,distr]=test_per_pat(t,0.9972695667,[.1 5],coin24,55.76);

%TEST_PER_PAT  test periodicity pattern of events
%
%    sp       spectrum
%    distr    spectrum distribution
%
%    t        events (sorted)
%    per0     true period (tsid = 0.9972695667)
%    pers[2]  min,max period to be considered
%    pat[]    period pattern (first value for 0 phase)
%    ph[]     phases to be considered (degrees); the phase are considered
%             as the phase of the periodicity at time 0; (for tsid and long
%             = 0, ph = 55.76)


%------- SIMULA EVENTI GRAVITAZIONALI CON PERIODICITA' SIDERALE -----------------------------------------

pplot(1:24,1)=coin24';
t=gw_even(86,[10 1000],0.9972695667,pplot,1);

% function [t,lam]=gw_even(n,tobs,periods,pplot,w)
%GW_EVEN  simulation of pulse events with periodicities
%
%   t             event times
%   lam           event lambda
%
%   n             number of events
%   tobs          [ini fin] observation time
%   periods(np)   periodicities periods
%   pplot(lp,np)  periodicities plots
%   w(np)         weights

%------- SIMULA EVENTI "STRANI" CON PERIODICITA' SOLARE -----------------------------------------

fin=15;
per1=ones(24*fin,1);
per1(2*fin+1:4*fin+1)=3;
pplot=0;
pplot(1:length(per1),1)=per1;
plot(pplot)
[t,lam]=gw_even(100,[10 1000],1,pplot,1);

ret=per1;
[spet,distr]=test_per_pat(t,1,[.1 5],ret,0);

%function [sp,distr]=test_per_pat(t,per0,pers,pat,ph)
%TEST_PER_PAT  test periodicity pattern of events
%
%    sp       spectrum
%    distr    spectrum distribution
%
%    t        events (sorted)
%    per0     true period (tsid = 0.9972695667)
%    pers[2]  min,max period to be considered
%    pat[]    period pattern (first value for 0 phase)
%    ph[]     phases to be considered (degrees); the phase are considered
%             as the phase of the periodicity at time 0; (for tsid and long
%             = 0, ph = 55.76)


%------- CERCA FLUTTUAZIONI -------------------------------------------

cerca_flutt([10 1000],86,21,3,100);
cerca_flutt([10 1000],86,21,3,1);

% function ntot=cerca_flutt(tobs,nev,nin,nore,n)
%CERCA_FLUTT   cerca fluttuazioni
%
%  si generano nev eventi in tobs(1) <-> tobs(2), si analizzano i casi in
%  cui ce ne siano almeno nin in nore ore solari successive. Si cercano n casi
%  positivi

%-------- CALCOLA PROBABILITA' DI CORRELAZIONE TRA 2001 E 2003 COL BOOTSTRAP --------------------

% function [corr,distr]=corr_bootstrap(in1,in2,n,nbins)
%CORR_BOOTSTRAP  evaluates the correlation with bootstrap method
%
%    corr     correlation coefficient
%    distr    correlation distribution
%
%    in1,in2  input series
%    n        number of permutations
%    nbins    number of bins in the histogram
