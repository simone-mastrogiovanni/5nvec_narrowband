function out=bsd_ob_d(bandin,dt0,Nfft0)
% search orthoband for given band, sampling time and Nfft
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
base_band=1/dt0;
out.base_band=base_band;

dfr0=1/(dt0*Nfft0);
fr0=floor(bandin(1)*dt0)/dt0;
out.fr0=fr0;
out.dfr0=dfr0;
fr1=floor(bandin(2)*dt0)/dt0;
out.fr1=fr1;

Nband=round((fr1-fr0)*dt0)+1;
out.Nband=Nband;

kbandin=round((bandin-fr0)/dfr0);

if Nband == 1
    out.obtyp=1;
    disp('Short band')
elseif Nband == 2 && bandin(2)-bandin(1) < base_band
    out.obtyp=2;
    disp('Inter-band --- CHANGE PARAMETERS')
else
    out.obtyp=3;
    disp('Multi-band --- FULL BAND')
end

out.kbandin=kbandin;

wkbandin=kbandin(2)-kbandin(1)+1;
out.wkbandin=wkbandin;
wkband=round(wkbandin*0.999);
iok=0;
iter=0;

while iok == 0
    iter=iter+1;
    [nbandw,rest]=modd(kbandin(1),wkband);
    out.kbandout(1)=nbandw*wkband+1;
    out.kbandout(2)=out.kbandout(1)+wkband-1;
    out.wkband=wkband;
    Nfft1=(floor(Nfft0/wkband)+1)*wkband;
    dfr1=1/(dt0*Nfft1);
    kbandin(1)=round((bandin(1)-fr0)/dfr1);
    kbandin(2)=kbandin(1)+wkbandin-1;
    fprintf('%d  %f  %f   %f  %f \n',wkband,out.kbandout(1)*dfr1+fr0,out.bandin(1),out.kbandout(2)*dfr1+fr0,out.bandin(2))
    if out.kbandout(1)*dfr1+fr0 <= out.bandin(1) && out.kbandout(2)*dfr1+fr0 >= out.bandin(2)
        iok=1;
    else
        wkband=wkband+1;
    end
end

out.Nfft1=Nfft1;
out.dfr1=dfr1;
out.bandw=dfr1*wkbandin;

out.bandout=out.kbandout*dfr1+fr0;
out.iter=iter;
kk0=ceil(Nfft0/wkbandin);
out.kk0=kk0;
dt=1./out.bandw;
out.dt=dt;

if out.obtyp == 2
    dt0=dt0/2;
    Nfft1=Nfft1*2;
    out.dt0=dt0;
    out.Nfft1=Nfft1;
end



function [C,D]=modd(A,B)

C=floor(A/B);
D=A-C*B;