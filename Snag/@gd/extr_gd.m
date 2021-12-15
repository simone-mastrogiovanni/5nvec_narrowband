function [y n dx ini capt x]=extr_gd(g) 
% EXTR_GD  extracts data from a gd
%
%    [y n dx inix capt x]=extr_gd(g)

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=x_gd(g);
y=y_gd(g);
n=n_gd(g);
dx=dx_gd(g);
ini=ini_gd(g);
capt=capt_gd(g);