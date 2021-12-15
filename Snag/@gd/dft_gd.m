function f=dft_gd(g)
%DFT_GD  discrete Fourier transform of a GD

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

f=g;
f.y=fft(g.y);
f.dx=1/(g.n*g.dx);

f.capt=['fft of ' g.capt];