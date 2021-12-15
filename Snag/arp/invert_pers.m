function outpers=invert_pers(inpers)
%INVERT_PERS  inverts allowed to not-allowed periods 
%
%   The first not-allowed period starts at 0. The last ends at 1e9.
%   At beginning it checks the consistency of inpers (times should be not-decrescent).
%
%   inpers  (n,2) array containing the start and stop time of the n allowed
%           periods (days)
%

% Version 2.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[n,m]=size(inpers);

iok=1;
a=inpers';
a=a(:);

if min(diff(a)) < 0
    error(' *** Inconsistent inpers vector')
    return
end

outpers=inpers*0;

for i = 1:n
    outpers(i,2)=inpers(i,1);
    outpers(i+1,1)=inpers(i,2);
end

outpers(n+1,2)=1.e9;