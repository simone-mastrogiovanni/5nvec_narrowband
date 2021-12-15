function [eps amp]=iota2eps(iota)
% IOTA2EPS  conversion from iota to epsilon for the periodic gw
%
%   iota   angle of the rotation axis respect the visual line (degrees)
%
%   eps    the difference between the normalized semiaxis of the polarization ellipse
%   amp    amplitude gain with iota
%
%   ATTENTION : the amplitude of the wave changes with iota !

% Version 2.0 - June 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

eps=(1-abs(cos(iota*pi/180)))./sqrt(1+(cos(iota*pi/180)).^2);

amp=sqrt(((1+cos(iota*pi/180).^2)/2).^2+cos(iota*pi/180).^2);