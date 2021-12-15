function sr=gw_harm_sidresp(antenna,source,n,typ)
%GW_HARM_SIDRESP  sidereal response for gravitational antennas based on
%                 harmonics analysis
%
%   antenna,source   pss structures
%   n                number of points
%   type             1 = linear, 2 = power

% Version 2.0 - September 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if antenna.type == 1
    notyet('bar');
else
    sr=harm_sidresp_interf(source,antenna,n,typ);
end