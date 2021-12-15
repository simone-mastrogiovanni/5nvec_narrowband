function gout=rescale_gd(gin,newscalex,newscaley)
% RESCALE_GD  rescales the abscissa and ordinate of a gd
%
%   newscalex   [a b]
%   newscaley   [a b] (if present)

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

gout=gin;

gout.dx=gout.dx*newscalex(1);
gout.ini=gout.ini*newscalex(1)+newscalex(2);

if exist('newscaley','var')
    gout.y=gout.y*newscaley(1)+newscaley(2);
end