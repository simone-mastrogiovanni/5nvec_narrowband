function [a,i,j]=maxmax(A)
% minimum in a matrix

[aa,ii]=max(A);
[a,j]=max(aa);
i=ii(j);