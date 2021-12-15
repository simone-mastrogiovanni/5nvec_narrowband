function out=monotonize(in,lowhi)
% monotonize a growing sequence
%
%   out=monotonize(in,lowhi)
%
%   in      input sequence
%   lowhi   1 low, 2 high

% Version 2.0 - July 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if lowhi ~= 2
    lowhi=1;
end

n=length(in);
out=in;

switch lowhi
    case 1
        for i = n-1:-1:2
            out(i)=min(out(i+1),in(i));
        end
    case 2
        for i = 2:n
            out(i)=max(out(i-1),in(i));
        end
end