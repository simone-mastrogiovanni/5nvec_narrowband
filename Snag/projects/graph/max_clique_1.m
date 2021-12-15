function [ncl CLQ]=max_clique_1(G)
% MAX_CLIQUE_0  computes the maximum clique 
%
%   ncl=max_clique_0(G)

ncl=isclique(G);
CLQ.maxclique=max(ncl,2);
CLQ.stop=0;
CLQ.level=1;
CLQ.count=0;
CLQ.mode=2;
CLQ.modes=zeros(1,3);

if ncl == 0
    CLQ=down_clique(G,CLQ);
end

ncl=CLQ.maxclique;