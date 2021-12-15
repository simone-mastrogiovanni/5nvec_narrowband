function cyc=perm_cycle(p,el)
% PERM_CYCLE  shows a permutation element cycle
%
%       cyc=perm_cycle(p,el)
%
%    p    permutation
%    el   element position

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(p);
cyc=zeros(1,n);
el1=el;

for i = 1:n
    el1=p(el1);
    cyc(i)=el1;
    if el1 == el
        break
    end
end

cyc=cyc(1:i);

i