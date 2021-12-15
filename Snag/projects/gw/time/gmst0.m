function st=gmst0(t)
%GMST  Greenwich mean sidereal time (in hours)
%
%   t   time (in JD or mjd)

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

jd=t;
if t < 1000000
    jd=t+2400000.5;
end

jd0=floor(jd-0.5)+0.5;
T=(jd-2451545)/36525;
h=(jd-jd0)*24;

st=mod(6.69737455833+h+T.*(2400.05133690722+T.*(2.5862e-5+1.722e-9.*T)),24);

