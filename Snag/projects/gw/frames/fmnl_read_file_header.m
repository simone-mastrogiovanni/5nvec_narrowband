function fmnl_read_file_header(fid)
%FMNL_READ_FILE_HEADER   reads a frame file header
%
%   Frame Matlab Native Library
%
%      fmnl_read_file_header(fid)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

igwd=fread(fid,4,'char');char(igwd)

form=fread(fid,1,'uchar')
vers=fread(fid,1,'uchar')
minvers=fread(fid,1,'uchar')
siz_int2=fread(fid,1,'uchar')
siz_int4=fread(fid,1,'uchar')
siz_int8=fread(fid,1,'uchar')
siz_real4=fread(fid,1,'uchar')
siz_real8=fread(fid,1,'uchar')

twbyt=fread(fid,1,'uint16')
fobyt=fread(fid,1,'uint32')
eibyt=fread(fid,1,'uint64')

pising=fread(fid,1,'float32')
pidobl=fread(fid,1,'float64')

az=fread(fid,2,'char');char(az)
