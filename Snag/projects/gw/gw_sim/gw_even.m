function [t,lam]=gw_even(n,tobs,periods,pplot,w)
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

% Version 2.0 - April 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

np=length(periods);
[lp np0]=size(pplot);
dt=min(periods)/lp;
tini=tobs(1);
DT=tobs(2)-tobs(1);

N=ceil(DT/dt);
lam=zeros(N,1);

for i = 1:N
    tt=tini+dt*(i-1);
    ind=floor((mod(tt,periods)*lp./periods))+1;%ind
    lam(i)=sum(pplot((0:np-1)+ind).*w);
end

F=cumsum(lam);
t=sim_event(rand(n,1),F,tobs);
t=sort(t);
