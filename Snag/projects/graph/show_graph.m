function show_graph(G,dim,g1)
% SHOW_GRAPH  plots a graph
%
%    show_graph(G)
%
%   G     graph matrix
%   dim   dimension (2 or 3)
%         if it is an array -> coord(n,dim) : in this case plot is fixed
%   g1    subgraph (only nodes)

if ~exist('dim','var')
    dim=2;
end
[i1 i2]=size(dim);
fixed=0;
if i2 > 1
    coord=dim;
    dim=i2;
    fixed=1;
end

[n n]=size(G);
[nod1 nod2]=find(G);
nedg=length(nod1);
rp=randperm(n);

if exist('g1','var')
    nn=1:n;
    nn(g1)=0;
    nn=find(nn);
    G1=G;
    for i = nn
        G1(:,i)=0;
        G1(i,:)=0;
    end
    [nod11 nod21]=find(G1);
    nedg1=length(nod11);
end

switch dim
    case 2
        nn=ceil(sqrt(n));

        if fixed
            x=coord(:,1);
            y=coord(:,2);
        else
            x=mod(1:n,nn)+rand(1,n);
            y=(1:n)/nn+rand(1,n);
            x=x(rp);
            y=y(rp);
        end

        figure
        plot(x,y,'r.'),hold on
        for i = 1:nedg
            plot([x(nod1(i)) x(nod2(i))],[y(nod1(i)) y(nod2(i))])
        end
        plot(x,y,'r.')
        for i = 1:n
            text(x(i),y(i),['\bf \color{magenta}' num2str(i)])
        end
        
        if exist('g1','var')
            for i = 1:nedg1
                plot([x(nod11(i)) x(nod21(i))],[y(nod11(i)) y(nod21(i))],'m')
            end
        else
            g1=1;
        end
        
        str=questdlg('Che faccio ?','Salvataggio grafo','salva','ripeti','lascia stare','lascia stare');
        switch str
            case 'salva'
                fid=fopen('graph2D.dat','w');
                fprintf(fid,'*  2-D graph, N_nod = %d ,  N_edg = %d \r\n',n,nedg);
                for i = 1:n
                    fprintf(fid,'2D %d %d \r\n',x(i),y(i));
                end
                
                for i = 1:nedg
                    if nod1(i) > nod2(i)
                        fprintf(fid,' %d %d \r\n',nod1(i),nod2(i));
                    end
                end
                
                fclose(fid);
            case 'ripeti'
                show_graph(G,dim,g1);
        end
    case 3
        nn=ceil(n.^(1/3));

        if fixed
            x=coord(:,1);
            y=coord(:,2);
            z=coord(:,3);
        else
            x=mod(1:n,nn)+rand(1,n);
            y=mod(0.5+nn*floor((1:n)/nn),nn^2)+rand(1,n);
            z=0.5+floor((1:n)/nn^2)+rand(1,n);
            x=x(rp);
            y=y(rp);
            z=z(rp);
        end
        
        figure
        plot3(x,y,z,'r.'),hold on
        for i = 1:nedg
            plot3([x(nod1(i)) x(nod2(i))],[y(nod1(i)) y(nod2(i))],[z(nod1(i)) z(nod2(i))])
        end
        plot3(x,y,z,'r.')
        for i = 1:n
            text(x(i),y(i),z(i),['\bf \color{red}' num2str(i)])
        end
        
        if exist('g1','var')
            for i = 1:nedg1
                plot3([x(nod11(i)) x(nod21(i))],[y(nod11(i)) y(nod21(i))],[z(nod11(i)) z(nod21(i))],...
                    'm','LineWidth',2)
            end
        else
            g1=1;
        end
        
        str=questdlg('Che faccio ?','Salvataggio grafo','salva','ripeti','lascia stare','lascia stare');
        switch str
            case 'salva'
                fid=fopen('graph3D.dat','w');
                fprintf(fid,'*  3-D graph, N_nod = %d ,  N_edg = %d \r\n',n,nedg);
                for i = 1:n
                    fprintf(fid,'3D %d %d %d \r\n',x(i),y(i),z(i));
                end
                
                for i = 1:nedg
                    if nod1(i) > nod2(i)
                        fprintf(fid,' %d %d \r\n',nod1(i),nod2(i));
                    end
                end
                
                fclose(fid);
            case 'ripeti'
                show_graph(G,dim,g1);
        end
end
        