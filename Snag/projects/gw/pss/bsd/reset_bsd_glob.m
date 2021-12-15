function bsd_glob_set=reset_bsd_glob()
% resets all global variables
%

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

global bsd_glob_noplot bsd_glob_level bsd_glob_stack bsd_glob_stacklev
global bsd_glob_nozeroing

bsd_glob_noplot=0
bsd_glob_level=0
bsd_glob_stack=0
bsd_glob_stacklev=0
bsd_glob_nozeroing=0

bsd_glob_set.noplot=bsd_glob_noplot;
bsd_glob_set.level=bsd_glob_level;
bsd_glob_set.stack=bsd_glob_stack;
bsd_glob_set.stacklev=bsd_glob_stacklev;
bsd_glob_set.bsd_glob_nozeroing=bsd_glob_nozeroing;