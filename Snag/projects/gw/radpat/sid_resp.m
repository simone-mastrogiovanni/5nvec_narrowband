function sr=sid_resp(antenna,source,n)
%SID_RESP  sidereal response for gravitational antennas
%
%   ATTENTION: old epsilon definition !
%
%   antenna,source   pss structures
%   n                number of points
%

% Version 2.0 - August 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


tsid=(0:(1/n):(1-1/n))*24;

if antenna.type == 1
    sr=angr85(antenna,source,tsid*15);
else
    sr=radpat_interf(source,antenna,tsid);
end

mean_sr=mean(sr)
f=fft(sr);
lines=abs(f(1:7))