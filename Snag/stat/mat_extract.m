function B=mat_extract(A,irc,p)
% extracts by chance a subser of rows (or columns) of a matrix
%
%       B=mat_extract(A,irc,p)
%
%   A     input matrix
%   irc   = 1 rows, = 2 columns
%   p     fraction to be taken

% Version 2.0 - August 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if irc == 2
    A=A';
end

[n m]=size(A);

nn=round(n*p)*2;
r=rand(1,nn);
ii=find(r <= p);
r=ceil(r*n);
r=unique(r);
r=r(1:nn/2);

B=A(r,:);

if irc == 2
    B=B';
end