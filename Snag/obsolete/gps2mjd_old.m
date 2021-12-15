function t=gps2mjd(tgps)
%GPS2MJD   conversion from gps time to mjd
%
%     t=gps2mjd(tgps)
%
%     tgps   gps time (in seconds)
%     t      mjd
%
%  GPS time is 0 at 6-Jan-1980 0:00:00 and it is linked to TAI.
%  It is offset from UTC for the insertion of the leap seconds.
%
%   *** TO BE UPGRADED EVERY SIX MONTHS
%
%       Leap seconds
%
% 1981 JUL  1 =JD 2444786.5  TAI-UTC=  20.0       S + (MJD - 41317.) X 0.0      S
% 1982 JUL  1 =JD 2445151.5  TAI-UTC=  21.0       S + (MJD - 41317.) X 0.0      S
% 1983 JUL  1 =JD 2445516.5  TAI-UTC=  22.0       S + (MJD - 41317.) X 0.0      S
% 1985 JUL  1 =JD 2446247.5  TAI-UTC=  23.0       S + (MJD - 41317.) X 0.0      S
% 1988 JAN  1 =JD 2447161.5  TAI-UTC=  24.0       S + (MJD - 41317.) X 0.0      S
% 1990 JAN  1 =JD 2447892.5  TAI-UTC=  25.0       S + (MJD - 41317.) X 0.0      S
% 1991 JAN  1 =JD 2448257.5  TAI-UTC=  26.0       S + (MJD - 41317.) X 0.0      S
% 1992 JUL  1 =JD 2448804.5  TAI-UTC=  27.0       S + (MJD - 41317.) X 0.0      S
% 1993 JUL  1 =JD 2449169.5  TAI-UTC=  28.0       S + (MJD - 41317.) X 0.0      S
% 1994 JUL  1 =JD 2449534.5  TAI-UTC=  29.0       S + (MJD - 41317.) X 0.0      S
% 1996 JAN  1 =JD 2450083.5  TAI-UTC=  30.0       S + (MJD - 41317.) X 0.0      S
% 1997 JUL  1 =JD 2450630.5  TAI-UTC=  31.0       S + (MJD - 41317.) X 0.0      S
% 1999 JAN  1 =JD 2451179.5  TAI-UTC=  32.0       S + (MJD - 41317.) X 0.0      S
%
%  To update, add the mjd value of the new leapseconds, computed with
%        t=s2mjd('1-jul-1981')
%  from the prompt of matlab (with the real date); update also nleap.

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

leaptimes=zeros(20,1);

leaptimes(1)=44786;
leaptimes(2)=45151;
leaptimes(3)=45516;
leaptimes(4)=46247;
leaptimes(5)=47161;
leaptimes(6)=47892;
leaptimes(7)=48257;
leaptimes(8)=48804;
leaptimes(9)=49169;
leaptimes(10)=49534;
leaptimes(11)=50083;
leaptimes(12)=50630;
leaptimes(13)=51179;

nleap=13;

t0=44244;

s1=1/86400;
t=tgps/86400+t0-s1*nleap;

for i = nleap:-1:1
   if t < leaptimes(i)
      t=t+s1;
   end
end
