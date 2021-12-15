function [G nod1 nod2 coord edge]=graph_read(file,cont)
% GRAPH_READ  reads a graph file (typically *.dat or *.clq)
%             dat file format:
%             each line an edge nod1(i)->nod2(i)
%             lines starting with  * -> comments
%             lines starting with 2D -> 2-D coordinates of nodes
%             lines starting with 3D -> 3-D coordinates of nodes
%
%             if extension clq, clq format
%
%   G=graph_read(file)
%
%   file   if present, input file
%   cont   1 -> oriented
%
%   G      graph matrix
%   nod1   init node
%   nod2   end node

if ~exist('file','var')
        file=uigetfile({'*.dat;*.clq'},'File da aprire ?');
end
if ~exist('cont','var')
    cont=0;
end

[pathstr, name, ext] = fileparts(file);
ic=0;
if strcmp(ext,'.clq');
    ic=1;
end

fid=fopen(file);
i=0;
nedg=0;
edge=0;
nnod=0;
coord=0;

while ~feof(fid)
    i=i+1;
    line=fgetl(fid);
    if line(1) == '*' || line(1) == 'c'
        disp(line)
    elseif line(1) == 'p'
        edge=sscanf(line(7:length(line)),' %d %d');
    elseif line(1) == 'e'
        aa=sscanf(line(2:length(line)),' %d %d');
        nedg=nedg+1;
        nod1(nedg)=aa(1);
        nod2(nedg)=aa(2);
    elseif strcmp(line(1:2),'2D')
        aa=sscanf(line(3:length(line)),' %f %f');
        nnod=nnod+1;
        coord(nnod,1)=aa(1);
        coord(nnod,2)=aa(2);
    elseif strcmp(line(1:2),'3D')
        aa=sscanf(line(3:length(line)),' %f %f %f');
        nnod=nnod+1;
        coord(nnod,1)=aa(1);
        coord(nnod,2)=aa(2);
        coord(nnod,3)=aa(3);
    else
        if ic == 0
            nedg=nedg+1;
            aa=sscanf(line,' %d %d');
            nod1(nedg)=aa(1);
            nod2(nedg)=aa(2);
        end
    end
end

nnod=max(max(nod1),max(nod2));

if cont == 1
    disp('Oriented graph')
else
    disp('Not oriented graph')
end
fprintf(' %d  lines read',i)
fprintf(' %d  nodes found',nnod)
fprintf(' %d  edges found',nedg)

G=zeros(nnod);

for i = 1:nedg
    G(nod1(i),nod2(i))=1;
    if cont ~= 1
       G(nod2(i),nod1(i))=1;
    end
end

[nod1 nod2]=find(G);

fclose(fid);