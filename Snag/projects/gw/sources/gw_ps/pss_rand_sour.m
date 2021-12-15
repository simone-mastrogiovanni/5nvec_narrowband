function [sour,sourstr]=pss_rand_sour(N,hh,fr,sd,detlev)
%
%    sour=pss_rand_sour(N,hh,fr,sd,detlev)
%
%   N      number of sources
%   hh     normalized [hmin hmax] log-uniform in the interval
%          if length(h) ~= 2, possible amplitude values
%          if length(hh)=N -> h values
%   fr     [frmin frmax method par]; if length(fr)=N -> frequencies 
%            method = 1 uniform in the range
%                   = 2 equispaced
%                   = 3 random in par bands (par <= N)
%   sd     spin-down [min max]; if length(sd)=N -> spin-down values
%   detlev detection level (as obtained by base_pss_eval; if present)
%
%   sour   [fr,lam,bet,sd,h,hnorm,eta,psi,alf,delt]
%     1         inj freq
%     2         inj lambda
%     3         inj beta
%     4         inj s.d.
%     5         inj h
%     6         inj hnorm
%     7         inj eta
%     8         inj psi
%     9         equivalent alfa
%    10         equivalent delta
%
% typical call: sour=pss_rand_sour(500,[0.1 10],[20,128,3],[-1e-11 1e-12],detlev);

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if exist('detlev','var')
    icdetl=1;
else
    icdetl=0;
end

if length(hh) == N
    hnorm=hh;
elseif length(hh) == 2
    hnorm=gen_logunif(N,hh);
else
    i=find(hh);
    hh=hh(i);
    ln=length(hh);
    hnorm=hh(mod(randperm(N),ln)+1);
end

if length(fr) ~= N
    switch fr(3)
        case 1
            fr=rand(1,N)*(fr(2)-fr(1))+fr(1);
        case 2
            dfr=(fr(2)-fr(1))/N;
            fr=(0:N-1)*dfr+fr(1);
        case 3
            n=fr(3);
            dfr=(fr(2)-fr(1))/n;
            fr=(mod(0:N-1,n)+rand(1,N))*dfr+fr(1);
    end
end

if length(sd) ~= N
    sd=rand(1,N)*(sd(2)-sd(1))+sd(1);
end

out=rand_point_on_sphere(N);

alfa=out(:,1);
delta=out(:,2);

[lambda,beta]=astro_coord('equ','ecl',alfa,delta);

if N > 1
    figure,plot(alfa,delta,'.'),grid on,title('sky')
end

psi=rand(1,N)*90;
cosiota=rand(1,N)*2-1;
eta=-2*cosiota./(1+cosiota.^2);

if icdetl > 0
    detl=gd_interp(detlev,fr);
    h=hnorm.*detl;
else
    h=hnorm;
end

if N > 1
    figure,plot(psi,eta,'.'),grid on,title('polarization')
    figure,plot(fr,sd,'.'),grid on,title('freq - s.d.')
    figure,semilogy(fr,h,'.'),grid on,title('freq - h')
    figure,plot(fr,hnorm,'.'),grid on,title('freq - hnorm')
end

sour=zeros(N,10);

sour(:,1)=fr;
sour(:,2)=lambda;
sour(:,3)=beta;
sour(:,4)=sd;
sour(:,5)=h;
sour(:,6)=hnorm;
sour(:,7)=eta;
sour(:,8)=psi;
sour(:,9)=alfa;
sour(:,10)=delta;

if N == 1
    sourstr.name='dummy';
    sourstr.f0=fr;
    sourstr.df0=sd;
    sourstr.ddf0=0;
    sourstr.a=alfa;
    sourstr.d=delta;
    sourstr.ecl=[lambda beta];
    sourstr.eta=eta;
    sourstr.psi=psi;
    sourstr.v_a=0;
    sourstr.v_d=0;
    sourstr.fepoch=51544;
    sourstr.pepoch=51544;
else
    sourstr='Not computed';
end
