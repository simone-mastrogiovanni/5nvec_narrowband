function compl=vec2complex(vec)
% creates a complex array from a vector r1 i1 r2 i2 ... 
%
%     compl=vec2complex(vec)

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(vec);

compl=vec(1:2:n)+1j*vec(2:2:n);
