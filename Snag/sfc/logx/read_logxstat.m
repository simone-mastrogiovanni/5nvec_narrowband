function logx_str=read_logxstat(logx_str)
%READ_LOGXSTAT  "reads" a logx stat variable as a logx_str element

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

stat=logx_str.stat;

logx_str.linlog=0;
if bit_extract(stat,7,7) == 1
    logx_str.linlog=1;
elseif bit_extract(stat,3,3) == 1
    logx_str.linlog=2;
end

logx_str.sign=bit_extract(stat,1,1);
if bit_extract(stat,2,2) == 1
    logx_str.sign=0;
end

logx_str.dimen=2.^bit_extract(stat,4,6);