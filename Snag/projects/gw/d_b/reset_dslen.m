function dslen=reset_dslen(dslen1,ntype,sp)
%RESET_DSLEN   resets the length of the ds in case of simulations
%
% If the data are simulated the ds length MUST be equal to the length of the spectrum
%
%         dslen=reset_dslen(dslen1,ntype,sp)

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ntype == 100
   dslen=length(sp)/2
else
   dslen=dslen1;
end
