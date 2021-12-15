function sbl_headblw(fid,nbl,tbl)
%SBL_HEADBLW  writes the block header
%
%   nbl    block number
%   tbl    block time

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fprintf(fid,'[BLN%011d]',nbl);
fwrite(fid,tbl,'double');