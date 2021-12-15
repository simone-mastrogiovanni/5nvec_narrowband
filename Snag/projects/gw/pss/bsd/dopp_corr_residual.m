function out=dopp_corr_residual(direc,T,icplot,ant)
% residuals after doppler correction (per deg)
%
%    out=dopp_corr_residual(direc,T)
%
%   direc    direction ([lam bet] or direct structure) or candidate
%   T        [min max] mjd or bsd
%   icplot   1 plot (def 0)
%   ant      (if T is not a bsd) ant structure

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

DT=0.02;
if ~exist('icplot','var')
    icplot=0;
end
if ~isfield(direc,'lam')
    aa=direc.a;
    dd=direc.d;
    [ll,bb]=astro_coord('equ','ecl',aa,dd);
else
    ll=direc.lam;
    bb=direc.bet;
%     [aa,dd]=astro_coord('ecl','equ',ll,bb);
end

if length(T) < 2
    dt=dx_gd(T);
    n=n_gd(T);
    cont=ccont_gd(T);
    t0=cont.t0;
    T=[t0 t0+n*dt/86400];
    eval(['ant=' cont.ant ';'])
end

vdop(:,1)=doppler(T(1):DT:T(2),1,ll,bb,ant.long,ant.lat,1);
vdop(:,2)=doppler(T(1):DT:T(2),1,ll,bb+1,ant.long,ant.lat,1);
vdop(:,3)=doppler(T(1):DT:T(2),1,ll,bb-1,ant.long,ant.lat,1);
vdop(:,4)=doppler(T(1):DT:T(2),1,ll-1,bb,ant.long,ant.lat,1);
vdop(:,5)=doppler(T(1):DT:T(2),1,ll+1,bb,ant.long,ant.lat,1);
out.vdop=vdop;
out.dvdop=diff(vdop)/DT;
out.maxvardvdop=max(out.dvdop(:,1))-min(out.dvdop(:,1));

evdopb(:,1)=vdop(:,2)-vdop(:,1);
evdopb(:,2)=vdop(:,1)-vdop(:,3);
evdopl(:,1)=vdop(:,1)-vdop(:,4);
evdopl(:,2)=vdop(:,5)-vdop(:,1);
out.evdopl=evdopl;
out.evdopb=evdopb;
out.devdopl=diff(evdopl)/DT;
out.devdopb=diff(evdopb)/DT;
out.maxvardevdop_l_1deg=max(out.devdopl(:,1))-min(out.devdopl(:,1));
out.maxvardevdop_b_1deg=max(out.devdopb(:,1))-min(out.devdopb(:,1));
out.elrangeperdeg=[min(out.devdopl(:,1)); max(out.devdopl(:,1))]';
out.ebrangeperdeg=[min(out.devdopb(:,1)); max(out.devdopb(:,1))]';
out.rap_l_1deg=out.maxvardvdop/out.maxvardevdop_l_1deg;
out.rap_b_1deg=out.maxvardvdop/out.maxvardevdop_b_1deg;

if icplot > 0
    figure,plot(out.devdopl),title('on lambda, corrected'),xlabel('days'),ylabel('Hz'),grid on
    figure,plot(out.devdopb),title('on beta, corrected'),xlabel('days'),ylabel('Hz'),grid on
    figure,plot(out.dvdop),title('not corrected'),xlabel('days'),ylabel('Hz'),grid on
    figure,plot(out.devdopl),grid on
    hold on,plot(out.devdopb)
    plot(out.dvdop),title('corrected and non-corrected'),xlabel('days'),ylabel('Hz')
end