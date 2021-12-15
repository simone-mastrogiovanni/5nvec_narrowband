function sds_=sds_openw(file,sds_)
%SDS_OPENW  open an sds file for writing
%
%   file      file to open
%   sds_      sds structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_.file=file;

sds_.label='#SFC#SDS';
if ~isfield(sds_,'prot')
    sds_.prot=1;
else
    disp(sprintf('protocol %s',sds_.prot))
end
sds_.coding=0;

sds_=sfc_openw(file,sds_);

for i = 1:sds_.nch
    fprintf(sds_.fid,'%128s',sds_.ch{i});%sds_.ch{i}
end
