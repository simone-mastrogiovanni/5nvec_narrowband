function nls=leap_seconds(mjd)
%LEAP_SECONDS  number of leap seconds at a certain mjd
%
%      from https://datacenter.iers.org/bulletins.php
%
%                             Leap seconds
%         (*** TO BE UPGRADED EVERY SIX MONTHS - prob next 2004)
%
%  1972 JAN  1 =JD 2441317.5  TAI-UTC=  10.0       S + (MJD - 41317.) X 0.0      S
%  1972 JUL  1 =JD 2441499.5  TAI-UTC=  11.0       S + (MJD - 41317.) X 0.0      S
%  1973 JAN  1 =JD 2441683.5  TAI-UTC=  12.0       S + (MJD - 41317.) X 0.0      S
%  1974 JAN  1 =JD 2442048.5  TAI-UTC=  13.0       S + (MJD - 41317.) X 0.0      S
%  1975 JAN  1 =JD 2442413.5  TAI-UTC=  14.0       S + (MJD - 41317.) X 0.0      S
%  1976 JAN  1 =JD 2442778.5  TAI-UTC=  15.0       S + (MJD - 41317.) X 0.0      S
%  1977 JAN  1 =JD 2443144.5  TAI-UTC=  16.0       S + (MJD - 41317.) X 0.0      S
%  1978 JAN  1 =JD 2443509.5  TAI-UTC=  17.0       S + (MJD - 41317.) X 0.0      S
%  1979 JAN  1 =JD 2443874.5  TAI-UTC=  18.0       S + (MJD - 41317.) X 0.0      S
%  1980 JAN  1 =JD 2444239.5  TAI-UTC=  19.0       S + (MJD - 41317.) X 0.0      S
%  1981 JUL  1 =JD 2444786.5  TAI-UTC=  20.0       S + (MJD - 41317.) X 0.0      S
%  1982 JUL  1 =JD 2445151.5  TAI-UTC=  21.0       S + (MJD - 41317.) X 0.0      S
%  1983 JUL  1 =JD 2445516.5  TAI-UTC=  22.0       S + (MJD - 41317.) X 0.0      S
%  1985 JUL  1 =JD 2446247.5  TAI-UTC=  23.0       S + (MJD - 41317.) X 0.0      S
%  1988 JAN  1 =JD 2447161.5  TAI-UTC=  24.0       S + (MJD - 41317.) X 0.0      S
%  1990 JAN  1 =JD 2447892.5  TAI-UTC=  25.0       S + (MJD - 41317.) X 0.0      S
%  1991 JAN  1 =JD 2448257.5  TAI-UTC=  26.0       S + (MJD - 41317.) X 0.0      S
%  1992 JUL  1 =JD 2448804.5  TAI-UTC=  27.0       S + (MJD - 41317.) X 0.0      S
%  1993 JUL  1 =JD 2449169.5  TAI-UTC=  28.0       S + (MJD - 41317.) X 0.0      S
%  1994 JUL  1 =JD 2449534.5  TAI-UTC=  29.0       S + (MJD - 41317.) X 0.0      S
%  1996 JAN  1 =JD 2450083.5  TAI-UTC=  30.0       S + (MJD - 41317.) X 0.0      S
%  1997 JUL  1 =JD 2450630.5  TAI-UTC=  31.0       S + (MJD - 41317.) X 0.0      S
%  1999 JAN  1 =JD 2451179.5  TAI-UTC=  32.0       S + (MJD - 41317.) X 0.0      S
%  2006 JAN  1 =JD 2453736.5  TAI-UTC=  33.0       S + (MJD - 41317.) X 0.0      S
%  2009 JAN  1 =JD 2453832.5  TAI-UTC=  34.0       S + (MJD - 41317.) X 0.0      S
%  2012 JUL  1 =JD 2456109.5  TAI-UTC=  35.0       S + (MJD - 41317.) X 0.0      S
%  2015 JUL  1 =JD 2457204.5  TAI-UTC=  36.0       S + (MJD - 41317.) X 0.0      S
%  2017 JAN  1 =JD 2457754.5  TAI-UTC=  37.0       S + (MJD - 41317.) X 0.0      S

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

leaptimes=zeros(30,1);

leaptimes(1)=41317;
leaptimes(2)=41499;
leaptimes(3)=41683;
leaptimes(4)=42048;
leaptimes(5)=42413;
leaptimes(6)=42778;
leaptimes(7)=43144;
leaptimes(8)=43509;
leaptimes(9)=43874;

leaptimes(10)=44786;
leaptimes(11)=45151;
leaptimes(12)=45516;
leaptimes(13)=46247;
leaptimes(14)=47161;
leaptimes(15)=47892;
leaptimes(16)=48257;
leaptimes(17)=48804;
leaptimes(18)=49169;
leaptimes(19)=49534;
leaptimes(20)=50083;
leaptimes(21)=50630;
leaptimes(22)=51179;
leaptimes(23)=53736;
leaptimes(24)=54832;
leaptimes(25)=56109;
leaptimes(26)=57204;
leaptimes(27)=57754;

nls=37; % max leap TO BE UPDATE FOR EACH NEW LEAP SECOND !

for i = (nls-10):-1:1
   if mjd > leaptimes(i)
       break
   end
   nls=nls-1;
end
