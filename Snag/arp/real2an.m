function an=real2an(r)
%REAL2AN  creates the analytical signal from a real one
%
%   r      a real double array
%   an     a complex double array

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

r=real(r);
l=length(r);
l1=l;
if mod(l,2) == 1
    l1=l+1;
    r(l1)=r(l);
end

sqr2=sqrt(2);
an=fft(r)*sqr2;
an(l1/2+1:l1)=0;

an=ifft(an);
an=an(1:l);

