function [ener,pos,wid,integ]=ipw_pulse(g,sqmod)
%IPW_PULSE  computes the energy, the position, the width and the integral of a pulse
%
%  g        the impulse (gd or array)
%
%  sqmod    if present, 1 does the square modulus, 0 no (for real positive
%            impulses and distributions). Default 1
%
%  ener   energy
%  pos    position
%  wid    width (half the "real" width: the standard deviation)
%  integ  the integral

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('sqmod')
    sqmod=1;
end

dx=1;
ini=1;

if ~isnumeric(g)
    dx=dx_gd(g);
    ini=ini_gd(g);
    g=y_gd(g);
end

integ=sum(g)*dx;

if sqmod
    g=abs(g).^2;
end
x=dx*(0:length(g)-1);

s=sum(g);

ener=s*dx;

pos=ini+sum(x.*g)/s;

wid=sqrt(sum((g/s).*(x-pos+ini).^2));