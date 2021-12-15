function in=clean_persist(in,t0,frcorr,perscut,dt,dfr)
% cleans a peak-table for shifted persistence
%
%    out=clean_persist(in,corr,pers)
%
%   in       input peak-table
%   t0       bsd init (mjd)
%   frcorr   frequency subheterodyne correction
%   perscut  persistence lines
%   dt       bsd sampling time
%   dfr      frequency half window

% Snag Version 2.0 - December 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio, O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

t=in(1,:);
[T,ia]=unique(t);
nT=length(T);
iT=(T-t0)*86400/dt+1;
FR=frcorr(iT);
n=length(t);
npers=length(perscut);

for i = 1:nT
    i1=ia(i);
    if i < nT
        i2=ia(i+1);
    else
        i2=n;
    end
    fr=in(2,i1:i2);
    for j = 1:npers
        frp=perscut(j);
        ii=find(fr > frp-dfr & fr < frp+dfr);
        jj=i1+ii-1;
        in(2,jj)=-abs(in(2,jj));
    end
end