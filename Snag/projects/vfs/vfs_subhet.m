function out=vfs_subhet(in,lfr)
% application of sub-heterodyne
%
%    [out,lfr]=vfs_subhet(in,lfr)
%
%   in    input data gd
%   lfr   sub-het varying frequency

% Version 2.0 - October 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(in);
n=n_gd(in);
% nl=length(lfr);
% lfr1=interp1(1:nl,lfr,(1:n)*(nl/n));

ph=cumsum(lfr)*dt*2*pi;
corr=exp(-1j*ph);
out=y_gd(in).*corr(:);
out=edit_gd(in,'y',out);