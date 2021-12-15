function out=chirp_fun_2(frs,res,DT,A,dt)
% chirp functions
%
%   frs   [frmin fa]
%   res   resolution
%   DT    time from frmin and fa
%   A     amplitude
%   dt    sampling time (checked)

% Version 2 - October 2018 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2018  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nbase=1000;
tsig=2/3;
pnp=1;

frmin=frs(1);
fra=frs(2);

dt0=1/ceil(2*res*fra);
out.dt0=dt0;
if dt > dt0
    fprintf('dt too large; max dt = %f \n',dt0)
%     return
end
out.dt=dt;

dfr1=(fra-frmin)/nbase;
fr1=frmin+(0:nbase-1)*dfr1;
t1=pnp(1)*(1-(fra./fr1).^(8/3));
t11=min(t1);
t12=max(t1);
t1=(t1-t11)/(t12-t11);
t1=t1*DT-DT;

out.fr1=fr1;
out.t1=t1;

n=round(DT/dt);
N=ceil(n/tsig);

out.t=(0:n-1)*dt-DT;
out.fr=spline(t1,fr1,out.t);

out.fi2=(16*pi*fra*pnp(1)/5)*(1-(fra./out.fr).^(5/3));
out.fi=cumsum(out.fr)*2*pi*dt;

h=((pi*out.fr).^(2/3)).*cos(out.fi);
h=A*h/max(h);
h(n+1:N)=0;
h=gd(h);
out.h=edit_gd(h,'dx',dt,'ini',-DT);
