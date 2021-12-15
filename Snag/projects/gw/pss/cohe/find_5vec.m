function out=find_5vec(sp)
% finds 5-vecs on a power spectrum
%
%   sp    spectrum chunk (possibly high resolution)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
sid_band=1/SD;

n=n_gd(sp);
df=dx_gd(sp);
f=x_gd(sp);
s=y_gd(sp);

% m=2*ceil(2*sid_band/df)+1;
m1=round(sid_band/df);
m2=round(2*sid_band/df);
m=m2+m1+1;
m0=m2+1;

out.df=df;
out.sid_band=sid_band;
out.m0=m0;
out.m1=m1;
out.m2=m2;
out.m=m;

b=zeros(1,m);
b(1)=0.2;
b(m1+1)=0.2;
b(m2+1)=0.2;
b(m1+m2+1)=0.2;
b(2*m2+1)=0.2;

fil=filter(b,1,s);

out.bfilt=b;
out.fr=f-m2*df;
out.fil=fil;

[A,I]=max(fil(m2+1:n-m2-1));
II=I+m2+1;
out.frs5v=f(II+[-m2 -m1 0 m1 m2])-m2*df;
out.max=A;