function [G nod1 nod2]=crea_graph(Nnod,p,file,cont)
% CREA_GRAPH  creates a graph 
%             file format:
%             each line an edge nod1(i)->nod2(i)
%             lines starting with * -> comments
%
%   G=graph_read(file)
%
%   Nnod   number of nodes
%   p      probability of an edge
%   file   output file
%   cont   1 -> oriented
%
%   G      graph matrix
%   nod1   init node
%   nod2   end node

if ~exist('file','var')
    file='graph.dat';
end
if ~exist('cont','var')
    cont=0;
end

fid=fopen(file,'w');

G=rand(Nnod);
for i = 1:Nnod
    G(i,i)=1;
    for j = 1:i-1
        G(j,i)=G(i,j);
    end
end

[nod1 nod2]=find(G<p);
nedg=length(nod1);

G=zeros(Nnod);
for i = 1:nedg
    G(nod1(i),nod2(i))=1;
end

if cont == 1
    disp('Oriented graph')
else
    disp('Not oriented graph')
end
disp(sprintf(' %d  nodes ',Nnod))
disp(sprintf(' %d  edges',nedg))

fprintf(fid,'*  Automatic graph, N_nod = %d ,  p = %f,  N_edg = %d \r\n',Nnod,p,nedg);

for i = 1:nedg
    fprintf(fid,' %d %d \r\n',nod1(i),nod2(i));
end

fclose(fid);