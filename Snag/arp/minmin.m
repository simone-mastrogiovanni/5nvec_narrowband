function [a,i,j]=minmin(A)
% minimum in a matrix

[aa,ii]=min(A,[],1);
[a,j]=min(aa);
i=ii(j);