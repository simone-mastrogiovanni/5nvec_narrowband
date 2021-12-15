function vbl_headchw(fid,ch,point)
%VBL_HEADCHW  writes the channel header (no special)
%
%   ch      channel data 
%     .numb
%     .dx 
%     .dy 
%     .lenx 
%     .leny
%     .inix 
%     .iniy 
%     .type
%   point   next channel pointer

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fprintf(fid,'[CH%04d]',ch.numb);
fwrite(fid,point,'int64');
fwrite(fid,ch.dx,'double');
fwrite(fid,ch.dy,'double');
fwrite(fid,ch.lenx,'int32');
fwrite(fid,ch.leny,'int32');
fwrite(fid,ch.inix,'double');
fwrite(fid,ch.iniy,'double');
fwrite(fid,ch.type,'int32');