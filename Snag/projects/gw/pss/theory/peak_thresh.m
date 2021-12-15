function P=peak_thresh(sig,thresh)
% probability to have a spectral peak over a threshold
%
%    sig      signal spectral amplitude
%    thresh   theshold
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(sig);
m=length(thresh);
P=zeros(n,m);
dx=0.1;
sig1=max(sig);

for j = 1:m
    x=thresh(j):dx:2*sig1+10;
    for i = 1:n
        P(i,j)=sum(peak_p(sig(i),x))*dx;
    end
end