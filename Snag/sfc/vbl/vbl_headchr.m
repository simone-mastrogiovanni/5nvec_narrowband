function vbl_=vbl_headchr(vbl_)
%VBL_HEADBLR reads the present block header

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

fid=vbl_.fid;
str1=fscanf(fid,'%3s',1);

switch str1
    case '[CH'
        k=fscanf(fid,'%4d');
        vbl_.ch0.chnum=k;
    otherwise
        str=sprintf('*** Error in vbl_headchr ! %s at byte %d',str1,ftell(fid));
        disp(str);
end

str1=fscanf(fid,'%1s',1);

vbl_.ch0.next=fread(fid,1,'int64');
vbl_.ch0.dx=fread(fid,1,'double');
vbl_.ch0.dy=fread(fid,1,'double');
vbl_.ch0.lenx=fread(fid,1,'uint32');
vbl_.ch0.leny=fread(fid,1,'uint32');
vbl_.ch0.inix=fread(fid,1,'double');
vbl_.ch0.iniy=fread(fid,1,'double');
vbl_.ch0.type=fread(fid,1,'int32');

vbl_.ch0.name=vbl_.ch(k).name;
