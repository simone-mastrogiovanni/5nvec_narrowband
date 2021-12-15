function [weq w5]=tsol_dist(gin,wien,ant)
% TSOL_DIST
%
%   gin       input data
%   wien      wiener vector
%

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86400;
cont=cont_gd(gin);
t0=ini_gd(gin);
alph=cont.alpha;
delt=cont.delta;
fr0=cont.appf0;
dt=dx_gd(gin);
N=floor(ST/dt);
long=ant.long;

weq=zeros(1,N)';
% yeq=weq;
y=y_gd(gin);
n=n_gd(gin);
tot=0;

for i = 1:N:n-N
    tot=tot+1;
    it1=round(mod(t0+(i-1)*dt,86400))+1;
    n1=N-it1;
    weq(it1:N)=weq(it1:N)+wien(i:i+n1);
    weq(1:it1-1)=weq(1:it1-1)+wien(i+n1+1:i+N-1);
end

weq=weq/tot;
% geq=edit_gd(gin,'y',yeq,'capt',['ST on ' capt_gd(gin)]);

x=(0:N-1)'*dt*2*pi/ST;

for i = 1:5
    w5(i)=sum(weq.*exp(1j*(i-3)*x))*dt;
end

w5=w5/N;

figure,plot(0:dt/3600:24-dt/3600,weq),grid on,xlabel('UT hours'),xlim([0 24])