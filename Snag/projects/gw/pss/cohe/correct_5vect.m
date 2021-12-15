function [d5 sidpat wins]=correct_5vect(gin,ant)
% correct_5vect  computes the correct 5-vect in presence of holes and high spin-down
%
%        [d5 sidpat wins]=correct_5vect(gin,ant)
%
%   gin       input data (holes must be 0)
%   ant       antenna structure
%

% Version 2.0 - February 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86164.09053083288;
N=240;

cont=cont_gd(gin);
t0=cont.t0;
sour=cont.sour;
sour=new_posfr(sour,t0);
fr0=cont.appf0;
df0=sour.df0;
ddf0=sour.ddf0;
dt=dx_gd(gin);
fr1=fr0-floor(fr0*dt)/dt;
long=ant.long;

% [A0 A45 Al Ar l0 l45 cr cl]=check_ps_lf(sour,ant,N);

wins=zeros(1,N)';
ys=wins;
y=y_gd(gin);
n=n_gd(gin);
x=x_gd(gin);
x=x-x(1);
y=y.*exp(-1j*2*pi*fr1.*x);
tot=0;

dtsd=df0*x.^2/(2*fr0)+ddf0*x.^3/(6*fr0);
t1=t0+(x-dtsd)/86400;
ts=(gmst(t1)*15+long)/360;
ts=mod(ts,1);
is=floor(ts*N+1);
ii=find(y);
nn=length(ii);
yc=y(ii);
yc=yc-mean(yc);

for i = 1:nn
    wins(is(ii(i)))=wins(is(ii(i)))+1;
    ys(is(ii(i)))=ys(is(ii(i)))+yc(i);
end

sidpat=ys./wins;

win=win*N/nn;
ds=ST/N;

x=(0:N-1)'*ds*2*pi/ST;

for i = 1:5
    d5(i)=sum(sidpat.*exp(-1j*(i-3)*x))*dt;
end

sidpat=gd(sidpat);
sidpat=edit_gd(sidpat,'dx',ds*24)