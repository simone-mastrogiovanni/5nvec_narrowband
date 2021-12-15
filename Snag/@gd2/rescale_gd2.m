function gout=rescale_gd2(gin,newscalex,newscaley)
% RESCALE_GD  rescales the abscissas of a gd
%
%   newscalex   [a b]
%   newscaley   [a b]

gout=gin;

gout.dx=gout.dx*newscalex(1);
gout.ini=gout.ini*newscalex(1)+newscalex(2);

gout.dx2=gout.dx2*newscaley(1);
gout.ini2=gout.ini2*newscaley(1)+newscaley(2);