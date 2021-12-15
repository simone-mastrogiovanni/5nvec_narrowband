function CLQ=down_clique(G,CLQ)
% DOWN_CLIQUE  checks a lower order clique
%
%    CLQ       clique structure
%       .ncl1
%       .clelem
%       .maxclique
%       .level
%       .stop
%       .mode    result mode: 0 do nothing, 1 clique found, 2 new level

CLQ.count=CLQ.count+1;
CLQ.modes(CLQ.mode+1)=CLQ.modes(CLQ.mode+1)+1;
CLQ.mode=0;
[n n]=size(G);
if n < CLQ.maxclique
    CLQ.stop=1;
    return
end

CLQ.level=CLQ.level+1;
CLQ.mode=1;
app=1:n;

for i = 1:n
    app(i)=0;
    app1=find(app);
    G1=G(app1,app1);
    ncl=isclique(G1);
    if ncl
        CLQ.ncl1=ncl;
        CLQ.clelem=app1;
        if CLQ.level+ncl > CLQ.maxclique
            CLQ.maxclique=CLQ.level+ncl;
        end
        return
    end
    app(i)=1;
end


CLQ.mode=2;
for i = 1:n  
    app(i)=0;
    app1=find(app);
    G1=G(app1,app1);
    CLQ=down_clique(G1,CLQ);
    app(i)=1;
    CLQ.level=CLQ.level-1;
    if ~CLQ.mode
        continue
    end
end