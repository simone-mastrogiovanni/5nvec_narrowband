function [v_eq,p_eq]=doptab2vp_eq(doptab,tin,tfi,DT)
% creates v_eq and p_eq from Pia's doptab
%
%    [v_eq,p_eq]=doptab2vp_eq(doptab,tin,tfi,DT)
%
%   doptab   doppler table for the antenna and time period
%   tin,tfi  initial, final time (mjd)
%   DT       time intervals (s)

% Version 2.0 - May 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t0=doptab(:,1);
i1=find(t0 < tin);
i1=max(i1);
i2=find(t0 > tfi);
i2=min(i2); 

t0=t0(i1:i2);
t1=mjd2gps(t0);
t1=t1-t1(1); 
n=floor(diff_mjd(tin,tfi)/DT);
t2=(1:n)*DT; 

v_eq=zeros(n,4);
p_eq=zeros(n,4);

p_eq(:,1)=spline(t1,doptab(i1:i2,2),t2);
p_eq(:,2)=spline(t1,doptab(i1:i2,3),t2);
p_eq(:,3)=spline(t1,doptab(i1:i2,4),t2);
p_eq(:,4)=t2;

v_eq(:,1)=spline(t1,doptab(i1:i2,5),t2);
v_eq(:,2)=spline(t1,doptab(i1:i2,6),t2);
v_eq(:,3)=spline(t1,doptab(i1:i2,7),t2);
v_eq(:,4)=t2;