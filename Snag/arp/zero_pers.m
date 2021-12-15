function vout=zero_pers(vin,t0,dt,alpers)
%ZERO_PERS  zeroes not allowed periods of a sampled data vector
%
%   vin     input sampled data vector
%   t0      time abscissa of first sample (days)
%   dt      sampling time (s)
%   alpers  (n,2) array containing the start and stop time of the n allowed
%           periods (days)
%

% Version 2.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=length(vin);
vout=vin;
[n,m]=size(alpers);

nopers=invert_pers(alpers);
pers=round((nopers-t0)*86400/dt+1);

for i = 1:n
    ini=pers(i,1);
    fin=pers(i,2);
    if ini <= 0
        ini = 1;
    end
    if ini > len
        break
    end
    if fin <= 0
        fin=-100;
    end
    if fin > len
        fin=len;
    end
    if (fin-ini) > 1
        vout(ini:fin)=0;
    end
end