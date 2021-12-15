function [ncl n nedg]=isclique(G)
% ISCLIQUE  test if the graph is a clique
%
%    ncl    0 -> not a clique; else the order of the clique
%
%    G      graph matrix

ncl=0;

[n n]=size(G);

nedg=sum(G(:));

if nedg == n*n-n
    ncl=n;
end