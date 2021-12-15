function [t1,dt,s2,g,g1,g2]=correct_pasco(t,s)
% CORRECT_PASCO corregge i dati acquisiti dal sistema Pasco
%
%    [t1,dt,s2,g,g1,g2]=correct_pasco(t,s);
%
%    t,s     dati originali
%
%    t1      tempi corretti
%    g       gd dati originali
%    g1      gd dati corretti
%    g2      gd dati campionati uniformemente

% Project LabMec - part of the toolbox Snag - May 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t1=t-s/344;
g=gd(s);
g=edit_gd(g,'x',t,'capt','pasco original data');
g1=gd(s);
g1=edit_gd(g,'x',t1,'capt','pasco corrected data');
n=length(t);
t0=t(1)-s(1)*2/344;
dt=(t(n)-s(n)*2/344-t0)/(n-1);
t2=t0+(0:(n-1))*dt;
s2=spline(t1,s,t2);
g2=gd(s2)
g2=edit_gd(g2,'ini',t0,'dx',dt,'capt','pasco uniform data');