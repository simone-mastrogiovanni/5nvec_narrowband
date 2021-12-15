function header=read_r87_noout(fid,reclen)
%READ_R87  reads string data in R87 format
%
%       header=read_r87_noout(fid,reclen)
%
% the file must be opened by open_r87
%

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=fread(fid,reclen,'int16');

if length(a) > 0
   header=read_header_r87(a);
else
   header.len=0;
   'stop'
end


