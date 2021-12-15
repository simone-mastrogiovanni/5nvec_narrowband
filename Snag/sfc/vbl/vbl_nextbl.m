function vbl_=vbl_nextbl(vbl_)
%VBL_NEXTBL reads the next block header

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if vbl_.nextblock > 0
    status=fseek(vbl_.fid,vbl_.nextblock,'bof');
end
vbl_=vbl_headblr(vbl_);
