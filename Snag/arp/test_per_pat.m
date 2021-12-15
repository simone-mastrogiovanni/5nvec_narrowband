function [sp,distr]=test_per_pat(t,per0,pers,pat,ph)
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

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(t);
frini=1/pers(2);
frfin=1/pers(1);
tobs=t(n)-t(1);
df=1/(4*tobs);
nf=ceil((frfin-frini)/df);
np=length(pat);
pat=(pat-mean(pat))/std(pat);
pat(np+1)=pat(1);
nph=length(ph);

sqrn=sqrt(n);

ph1=ph*per0/360;
t0=0;
if nph == 1
    t0=ph1;
end
for i = 1:nph
	t1=mod(t+ph1(i),per0)*np/per0;
	p1=interp1(0:np,pat,t1);
    s=sum(p1)/sqrn;
    disp(sprintf(' phase %f -> amp = %f',ph(i),s))
end

fr=frini;
sp=zeros(nf,1);
x=sp;

for i = 1: nf
    per=1/fr;
	t1=mod(t+t0,per)*np/per;
	p1=interp1(0:np,pat,t1);
    sp(i)=sum(p1)/sqrn;
    x(i)=fr;
    fr=fr+df;
end

figure,plot(pat);grid on, zoom on
figure,plot(x,sp);grid on

mi=min(sp);
ma=max(sp);
x=(0:100)*(ma-mi)/100+mi;
hi=hist(sp,x);
hi=fliplr(hi(:).');
distr=cumsum(hi)/nf;
distr=fliplr(distr(:).');

figure, semilogy(x,distr);grid on, zoom on
disp(sprintf('   mean, dev.st. = %f , %f',mean(sp),std(sp)))



    
