function [va,vd,ve]=get_gd2_vdetect(g)
%GET_GD2_VDETECT   gets the auxiliary variables for detector velocity (SFDB)
%
%       [va,vd,ve]=get_gd2_vdetect(g)
%
%    g           the gd2
%
%  The variables got are g.va, g.vd, g.ve

% Version 1.0 - September 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

va=g.va;
vd=g.vd;
ve=g.ve;