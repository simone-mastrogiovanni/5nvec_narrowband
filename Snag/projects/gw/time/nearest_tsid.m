function [t,t1,t2]=nearest_tsid(ts,t0)
% nearest time (mjd) for a given Greenwich tsid
%
%   ts   given tsid (hour)
%   t0   actual time (mjd)
%
%   t    nearest time
%   t1   nearest time before
%   t2   nearest time after

% Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

SD=86164.09053083288;
sidday=SD/86400;

t0s=gmst(t0);

dif=(t0s-ts)/24; % in sidereal days
tt=t0-dif*sidday;
if tt > t0
    t1=tt-sidday;
    t2=tt;
else
    t2=tt+sidday;
    t1=tt;
end

t=t1;
if t2-t0 < 0.5
    t=t2;
end

% fprintf('t0=%f t1=%f t2=%f ts=%f t0s=%f dif=%f t=%f \n',t0,t1,t2,ts,t0s,dif,t)
% gmst(t1),gmst(t2)