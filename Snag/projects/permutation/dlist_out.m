function [lout,nout]=dlist_out(lin,kout)
% DLIST_OUT  eliminates one or more items from a double array
%
%    [lout,nout]=dlist_out(lin,kout)
%
%  lin    input array
%  kout   sequence number of the elements to be eliminated
%
%  lout   output array
%  nout   number of output elements

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

kout=sort(kout);
kout(2:length(kout))=diff(kout);
[i1,i2,kout]=find(kout);
kout=cumsum(kout);
n=length(kout);
nin=length(lin);
lout=lin;
nout=nin;

for i = n:-1:1
    ii=kout(i);
    nout=nout-1;
    lout(1:ii-1)=lout(1:ii-1);
    lout(ii:nout)=lout(ii+1:nout+1);
end

lout=lout(1:nout);
