function vbl_write(fid,sbhead,type,vec)
%VBL_WRITE  writes a sub-block vector
%
%   sbhead    sub-block header (depends on the type of data)
%   type      data type
%   vec       data vector or matrix

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch type
    case 1
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       fwrite(fid,vec,'char');
    case 2
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       fwrite(fid,vec,'int16');
    case 3
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       fwrite(fid,vec,'int32');
    case 4
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       fwrite(fid,vec,'float');
    case 5
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       c_fwrite(fid,vec,'float');
    case 6
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       fwrite(fid,vec,'double');
    case 7
       fwrite(fid,sbhead(1),'double'); 
       fwrite(fid,sbhead(2),'double');
       c_fwrite(fid,vec,'double');
end
