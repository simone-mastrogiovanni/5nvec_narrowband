function vbl_=vbl_headblr(vbl_)
%VBL_HEADBLR reads the present block header

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=vbl_.fid;
str1=fscanf(fid,'%4s',1);
bln=0;

switch str1
    case '[BLN'
        bln=fscanf(fid,'%11d');
    case '[BLE'
        bln=fscanf(fid,'%11d');
        str=sprintf('--> Extraordinary Block %d',bln);
        disp(str);
    otherwise
        str=sprintf('*** Error in vbl_headblr ! %s at byte %d',str1,ftell(fid));
        disp(str);
        vbl_.eof=3;
end

str1=fscanf(fid,'%1s',1);
vbl_.block=bln;
vbl_.bltime=fread(fid,1,'double');
vbl_.nextblock=fread(fid,1,'int64');

vbl_.eob=0;
