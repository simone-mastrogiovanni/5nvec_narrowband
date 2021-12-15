function peakout=sd_corr_pm(peakin,sd,epoch0)
% corrects the spin-down in a peakmap
%
%    peakout=sd_corr_pm(peakin,sd,epoch0)
%
%   peakin   input peakmap
%   sd       spin-down
%   epoch0   frequency epoch (mjd)

% Snag version 2.0 - February 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

peakout=peakin;
peakout(2,:)=peakin(2,:)-(peakin(1,:)-epoch0)*85400*sd;