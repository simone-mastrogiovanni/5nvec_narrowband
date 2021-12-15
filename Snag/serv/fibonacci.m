function F=fibonacci(n)
% FIBONACCI  creates a Fibonacci sequence
%
%    f=fibonacci(n)
%
%   n   length of the sequence

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

in=zeros(1,n-1);
in(1)=1;
in(2)=1;
b=1;
a=[1 -1 -1];
F=filter(b,a,in);
F=[1 F];