function a=unc_gd(g)
%GD/UNC_GD uncertainty extractor
%
%  g   gd in

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isempty(g.unc)
    a=g.y*0;
else
    a=g.unc;
end