function [GG p G1]=graph_power(G,np)
% GRAPH_POWER  computes graph powers
%
%     graph_power(G,np)
%
%    G    graph matrix
%    np   power

[n n]=size(G);

for i = 1:n
    nr=length(find(G(i,:)));
    G1(i,:)=G(i,:);
    if nr > 0
        G1(i,:)=G(i,:)/nr;
    end
end

GG=G1^np;

p=GG*ones(n,1)/n;