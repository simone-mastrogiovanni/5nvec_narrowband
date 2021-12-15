function simfil_write(sfil,y,n)
%simfil_write   writes a "simple file"
%
%      simfil_write(sfil,y,n)
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
   fprintf(sfil.fil,'%15.6e\n',y);
else
   y=fwrite(sfil.fil,y,'float32');
end
