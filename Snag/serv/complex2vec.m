function vec=complex2vec(compl)
% creates a vector r1 i1 r2 i2 ... from a complex array
%
%     vec=complex2vec(compl)

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(compl);

vec(1:2:2*n)=real(compl);
vec(2:2:2*n)=imag(compl);
