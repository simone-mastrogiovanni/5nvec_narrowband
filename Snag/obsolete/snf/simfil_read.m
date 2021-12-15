function y=simfil_read(sfil,n)
%simfil_read   reads a "simple file"
%
%      y=simfil_read(sfil,n)
%
%   sfil   "simple file" structure
%   n      number of requested data (0 means all)
%
%   y      output array

% Version 1.0 - September 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 2000  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nx=sfil.nx;
ny=sfil.ny;
if n > 0
   nx=n;
   ny=1;
end

if sfil.type == 1
   y=fscanf(sfil.fil,'%e',[nx,ny]);
else
   y=fread(sfil.fil,[nx,ny],'float32');
end
