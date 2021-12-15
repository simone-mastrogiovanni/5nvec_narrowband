function str=fmnl_read_string(fid)
%FMNL_READ_STRING  reads a string in frame format
%
%        str=fmnl_read_string(fid)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=fread(fid,1,'uint16');

st=fread(fid,len,'uchar');

str=char(st');