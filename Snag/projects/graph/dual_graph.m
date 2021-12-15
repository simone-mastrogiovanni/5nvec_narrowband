function GD=dual_graph(G,typ)
% DUAL_GRAPH  creates dual graph
%
%
%
%    G     graph input matrix
%    typ   1 -> no loop, 2 -> loop possible

if ~exist('typ','var')
    typ=1;
end

[n n]=size(G);

GD=ones(n)-G;
if typ == 1
    for i = 1:n
        GD(i,i)=0;
    end
end