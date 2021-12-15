function a=ccont_gd(g)
%GD/CCONT_GD  control variable excluding tfstr and adv

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=g.cont;

if isstruct(a)
    if isfield(a,'tfstr')
        a=rmfield(a,'tfstr');
    end
    if isfield(a,'adv')
        a=rmfield(a,'adv');
    end
end