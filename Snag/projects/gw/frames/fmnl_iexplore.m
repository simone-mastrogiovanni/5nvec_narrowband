function file=fmnl_iexplore
%FMNL_IEXPLORE  interactive access to fmnl_explore
%
%      file=fmnl_iexplore

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
file=selfile(virgodata);

vers=fmnl_chkver(file);

if vers >=4
  fmnl_explorefr4(file); 
else
  fmnl_explore(file);
end
