function sds_seek(sds_,ind)
% SDS_SEEK  position to the ind sample
%
%    sds_   sds structure
%    ind    ind sample to read

% Version 2.0 - July 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

status=fseek(sds_.fid,sds_.point+4*(ind-1),'bof');

if status == -1
    disp('*** Error accessing file')
    disp(ferror(sds_.fid));
end