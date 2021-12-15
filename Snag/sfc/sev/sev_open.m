function [sev_ user]=sev_open(file)
%SEV_OPEN   opens an existing sev file and initialize the sev structure;
%           if pers (periods) is specified, opens the first file with data in
%           one of the defined ranges; in this case the operation is logged.
%
%    file        file to open
%
%    sev_        sev structure
%    user        user header (string)

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


sev_=sfc_open(file);
fid=sev_.fid;

if fid == -1
    if noper == 0
        fprintf(fidlog,'Non-existing file %s  \r\n',file);
        fclose(fidlog);
    end
    return
end

sev_.userlen=sev_.point0-(944+128*sev_.nch);

for i = 1:sev_.nch
    ch=fread(fid,128,'char');
    sev_.ch{i}=blank_trim(char(ch'));
end

if sev_.userlen > 0
    user=fread(fid,sev_.userlen,'uchar');
    user=char(user');
else
    user='no';
end

fseek(fid,sev_.point0,'bof');
sev_.nd=fread(fid,1,'int32');
sev_.ni=fread(fid,1,'int32');
sev_.nf=fread(fid,1,'int32');
sev_.lar=fread(fid,1,'int32');

sev_.evlen=sev_.nd*8+(sev_.ni+sev_.nf+sev_.lar)*4;

sev_.eof=0;
