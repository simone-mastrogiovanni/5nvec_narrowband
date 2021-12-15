function out=y_vfs_subhet_pos(y,fr,pos)
% application of sub-heterodyne
%
%    out=y_vfs_subhet_pos(y,fr,pos)
%
%   y     input data 
%   fr    frequency (fixed or varying)
%   pos   position (normalized by c)

% Version 2.0 - October 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

n=length(y);

ph=pos.*fr*2*pi;

corr=exp(-1j*ph);
out=y.*corr(:);