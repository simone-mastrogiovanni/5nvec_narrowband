function [G nod1 nod2]=clq_read(file)
% GRAPH_READ  reads a .clq file
%
%   [G nod1 nod2]=clq_read(file)
%
%   file   if present, input fil
%
%   G      graph matrix
%   nod1   init node
%   nod2   end node

if ~exist('file','var')
        file=uigetfile({'*.clq'},'File da aprire ?');
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
    if line(1) == 'c'
        disp(line)
    elseif line(1) == 'p'
        edge=sscanf(line(7:length(line)),' %d %d');
    elseif line(1) == 'e'
        aa=sscanf(line(2:length(line)),' %d %d');
        nedg=nedg+1;
        nod1(nedg)=aa(1);
        nod2(nedg)=aa(2);
    end
end

nnod=max(max(nod1),max(nod2));

fprintf(' %d  lines read \n',i)
fprintf(' %d  nodes found \n',nnod)
fprintf(' %d  edges found \n',nedg)

G=zeros(nnod);

for i = 1:nedg
    G(nod1(i),nod2(i))=1;
    G(nod2(i),nod1(i))=1;
end

[nod1 nod2]=find(G);

fclose(fid);