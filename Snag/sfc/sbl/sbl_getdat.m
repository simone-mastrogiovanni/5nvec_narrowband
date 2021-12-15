function [dat,sbl_]=sbl_getdat(sbl_,chn,inif,nf,init,nt)
%SBL_GETDAT   to get a vector of data from an sbl file
%
%    dat      output data (nf,nt)
%    sbl_     sbl structure
%    chn      channel number
%    inif     sequence position in f (starting from 1)
%    nf       number of data per bloc
%    init     initial bloc in f (starting from 1)
%    nt       number of blocs

% Version 2.0 - March 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

