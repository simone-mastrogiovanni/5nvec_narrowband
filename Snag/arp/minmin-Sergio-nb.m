function [a,i,j]=minmin(A)
% minimum in a matrix

[aa,ii]=min(A);
[a,j]=min(aa);
i=ii(j);