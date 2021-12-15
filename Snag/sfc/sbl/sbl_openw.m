function sbl_=sbl_openw(file,sbl_)
%SBL_OPENW  open an sbl file for writing
%
%   file      file to open
%   sbl_      sbl structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sbl_.file=file;

sbl_.label='#SFC#SBL';
sbl_.prot=1;
sbl_.coding=0;

sbl_=sfc_openw(file,sbl_);
fid=sbl_.fid;

for i = 1:sbl_.nch
    fwrite(fid,sbl_.ch(i).dx,'double');
    fwrite(fid,sbl_.ch(i).dy,'double');
    fwrite(fid,sbl_.ch(i).lenx,'int32');
    if sbl_.ch(i).leny < 1
        sbl_.ch(i).leny=1;
    end
    fwrite(fid,sbl_.ch(i).leny,'int32');
    fwrite(fid,sbl_.ch(i).inix,'double');
    fwrite(fid,sbl_.ch(i).iniy,'double');
    fwrite(fid,sbl_.ch(i).type,'int32');
    fprintf(fid,'%84s',sbl_.ch(i).name);
end
