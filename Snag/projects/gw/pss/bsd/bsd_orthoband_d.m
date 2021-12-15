function out=bsd_orthoband_d(bandin,dt0,Nfft0)
% search orthoband for given sampling time and Nfft
%
%   bandin   input band
%   dt0      base sampling time
%   Nfft0    length of the ffts (number of frequencies)

% Snag Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out.bandin=bandin;
out.dt0=dt0;
out.Nfft0=Nfft0;

dfr0=1/(dt0*Nfft0);
fr0=floor(bandin(1)*dt0)/dt0;
out.fr0=fr0;
out.dfr0=dfr0;

kbandin=round((bandin-fr0)/dfr0);
bandin_d=kbandin*dfr0+fr0;

out.kbandin0=kbandin;
out.bandin_d0=bandin_d;

kbandinw=kbandin(2)-kbandin(1);
out.kbandinw0=kbandinw;
kbandw=round(kbandinw*0.999);
iok=0;
iter=0;

while iok == 0
    iter=iter+1;
    [nbandw,rest]=modd(kbandin(1),kbandw);
    out.kbandout(1)=nbandw*kbandw;a1(iter)=out.kbandout(1);
    out.kbandout(2)=out.kbandout(1)+kbandw;a2(iter)=out.kbandout(2);
    out.kbandw=kbandw;
    if out.kbandout(1) <= out.kbandin0(1) && out.kbandout(2) >= out.kbandin0(2)
        iok=1;
    else
        kbandw=kbandw+1;
    end
end

% out.bandout=out.kbandout*dfr0+fr0;
out.iter0=iter;
kk0=ceil(Nfft0/kbandinw);
out.kk0=kk0;
Nfft1=out.kk0*kbandinw;
out.Nfft1=Nfft1;
dfr1=1/(dt0*out.Nfft1);
out.dfr1=dfr1;

kbandin=round((bandin-fr0)/dfr1);
bandin_d=kbandin*dfr1+fr0;

out.kbandin=kbandin;
out.bandin_d=bandin_d;

kbandinw=kbandin(2)-kbandin(1);
out.kbandinw=kbandinw;
kbandw=round(kbandinw*0.999);
iok=0;
iter=0;

while iok == 0
    iter=iter+1;
    [nbandw,rest]=modd(kbandin(1),kbandw);
    out.kbandout(1)=nbandw*kbandw;b1(iter)=out.kbandout(1);
    out.kbandout(2)=out.kbandout(1)+kbandw;b2(iter)=out.kbandout(2);
    out.kbandw=kbandw;
    if out.kbandout(1) <= out.kbandin(1) && out.kbandout(2) >= out.kbandin(2)
        iok=1;
    else
        kbandw=kbandw+1;
    end
end

kk1=ceil(Nfft1/kbandinw);
out.kk1=kk1;
Nfft1=out.kk1*kbandinw;
out.Nfft1=Nfft1;
dfr1=1/(dt0*out.Nfft1);
out.dfr1=dfr1;


out.bandout=out.kbandout*dfr1+fr0;
out.nbandw=nbandw;
out.bandw=kbandw*dfr1;
out.rest=rest;
  
dt=1./out.bandw;
out.dt=dt;
out.iter1=iter;
out.bandout1=out.kbandout*dfr1+fr0;
out.bandw1=dfr1*kbandinw;
out.dt1=1/out.bandw1;
out.a1=a1;
out.a2=a2;
out.b1=b1;
out.b2=b2;


function [C,D]=modd(A,B)

C=floor(A/B);
D=A-C*B;