function dds_=dds_openw(file,dds_)
%dds_OPENW  open an dds file for writing
%
%   file      file to open
%   dds_      dds structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dds_.file=file;

dds_.label='#SFC#DDS';
dds_.prot=1;
dds_.coding=0;

dds_=sfc_openw(file,dds_);

for i = 1:dds_.nch
    fprintf(dds_.fid,'%128s',dds_.ch{i});%dds_.ch{i}
end
