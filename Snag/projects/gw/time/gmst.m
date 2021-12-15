function st=gmst(t)
%GMST  Greenwich mean sidereal time (in hours)
%
%   t   time (in JD or mjd)
%
% add longitude in hours (deg/15) to have local sidereal time

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

jd=t;
if t < 1000000
    jd=t+2400000.5;
end

jd0=floor(jd-0.5)+0.5;
h=(jd-jd0)*24;

d=jd-2451545;
d0=jd0-2451545;
T=d/36525;

st=mod(6.697374558+0.06570982441908*d0+1.00273790935*h+0.000026*T.^2,24);
%st=mod(18.697374558 + 24.06570982441908*d,24);

