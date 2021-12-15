function v5s=det_5vec_sig(sig,t0,fr0,rasc,long)
% 5-vect detection for basic signals (as that created with sim_5vec_sig)
%
%   v5s=det_5vec_sig(sig,fr0)
%
%  sig    signal gd
%  fr0    central frequency (aliased)
%  rasc   source right ascension
%  long   antenna longitude

% Snag version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

FS=1/86164.09053083288;
Dfr=(-2:2)*FS;
fr=fr0+Dfr;fr

N=n_gd(sig);
dt=dx_gd(sig);
y=y_gd(sig);

[mjd,t1,t2]=t_culm(long,rasc,t0);
Dt0=diff_mjd(mjd,t0);
% 
% st=gmst(t0)*3600;
% t=(0:N-1)*dt+st;

v5s=zeros(5,1);
tt=(0:N-1)*dt+Dt0;
T0=N*dt;

for j = 1:5
    v5s(j)=sum(y.*exp(-1j*2*pi*fr(j).*tt'))/T0;
end