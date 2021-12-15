function [A,nread,eofstat]=psc_readcand(fid,N)
%PSC_READCAND  reads the candidates of candidate file
%
%    [A,nread,eofstat]=psc_readcand(fid,N)
%
%  fid      file identifier
%  N        desired number of candidates
%
%  A        candidate vector
%  nread    number of obtained candidates
%  eofstat  = 1 end of file

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[A,nread]=fread(fid,N*8,'uint16');

nread=floor(nread/8);

eofstat=feof(fid);