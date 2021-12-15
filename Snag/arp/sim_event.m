function x=sim_event(X,F,xlim)
%SIM_EVENT  simulates events with cumulative distribution F and cum prob X
%           typically if X is uniform in (0,1), x has cum distr F
%
%       X     cumulative probability
%       F     cumulative distribution; can be not normalized
%       xlim  x of the first and last sample of F

% Version 2.0 - April 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(X);
nF=length(F);
dx=(xlim(2)-xlim(1))/(nF-1);

F=F/F(nF);
[XX,IX]=sort(X);
j1=1;
x=XX*0;
r=rand(n,1);

for i = 1:n
    for j = j1:nF
        if F(j) > XX(i)
            j1=j;
            x(i)=xlim(1)+dx*(j-1+r(i));
            break
        end
    end
end

x=x(IX);