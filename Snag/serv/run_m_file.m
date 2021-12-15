% RUN_M_FILE
%
% needs the two variables dirTofile and filTorun

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen([dirTofile filTorun]);
aOffile=fread(fid,inf,'uchar');
aOffile=char(aOffile');
eval(aOffile);
fclose(fid);
