function rp=gw_radpat(antenna,source,t)
%GW_RADPAT  radiation pattern for gravitational antennas
%
%   antenna,source   pss structures
%   t                TAI (in mjd days)
%
%   *** PROVVISORIA ***

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mjd=tai2mjd(t);
tsid=gmst(mjd);

if antenna.type == 1
    rp=angr85(antenna,source,tsid*15);
else
    rp=radpat_interf(source,antenna,tsid);
end