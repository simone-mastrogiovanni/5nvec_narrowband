function b=onlypos(a)
%ONLYPOS   substitutes non positive values with min/2

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

amin=min(a(find(a>0)))/2;
b=a;
b(find(a<=0))=amin;
