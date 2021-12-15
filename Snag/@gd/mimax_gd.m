function [xmimax ymimax]=mimax_gd(gin)
% min,max for abscissa and ordinates
%
%   [xmimax ymimax]=mimax_gd(gin)
%
%   gin    input gd

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

x=x_gd(gin);
mi=min(x);
ma=max(x);
xmimax=[mi ma];

mi=min(gin.y);
ma=max(gin.y);
ymimax=[mi ma];