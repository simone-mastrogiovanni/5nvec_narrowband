function h=sp2hdens(sp)
%SP2HDENS  from a spectrum, creates a unilateral h-density
%
%  sp  power spectrum gd

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

y=y_gd(sp);
n=length(y);
y=sqrt(y*2);

h=sp;
h=edit_gd(h,'y',y,'capt',['h_dens from ' capt_gd(h)]);