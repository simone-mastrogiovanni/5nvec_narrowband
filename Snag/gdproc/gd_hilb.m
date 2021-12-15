function g=gd_hilb(a)
%ANALYSIS\GD_HILB  hilbert transform

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=a;

y=y_gd(a);
y=fft(y);
n=length(y);
y(n/2+1:n)=0;

y=ifft(y);

g=edit_gd(g,'y',y,'addcapt','hilb transf on:');