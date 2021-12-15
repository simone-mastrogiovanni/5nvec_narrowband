function [ncl cl]=max_clique_0(G)
% MAX_CLIQUE_0  computes the maximum clique 
%
%   ncl=max_clique_0(G)

[n n]=size(G);
nn=(1:n)';
ncl=0;

for i = 1:2^n
    sb=dec2bin(i,n);
    b=sscanf(sb,'%1d',n);
    ij=b.*nn;
    ij=find(ij);
    G1=G(ij,ij);
    ncl1=isclique(G1);
    if ncl1 > ncl
        ncl=ncl1;
        cl=ij;
    end
end

show_graph(G,3,cl)