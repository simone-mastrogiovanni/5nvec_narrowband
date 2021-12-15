function vbl_headblw(fid,nbl,tbl,point)
%VBL_HEADBLW  writes the block header
%
%   nbl    block number
%   tbl    block time
%   point  next block pointer

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fprintf(fid,'[BLN%011d]',nbl);
fwrite(fid,tbl,'double');
fwrite(fid,point,'int64');