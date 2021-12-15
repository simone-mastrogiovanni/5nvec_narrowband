function yout=half2fullspec(yin)
%HALF2FULLSPEC  creates a full (hermitian) spectrum from the first half
%
% operates on double array

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(yin);

yout=yin;
yout(1)=real(yin(1));
yout(n+1)=real(yin(n));
yout(n+2:2*n)=conj(yin(n:-1:2));