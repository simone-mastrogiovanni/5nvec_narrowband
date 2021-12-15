function [X,Y]=mtostairs(x,y);
%MTOSTAIRS  creates an (X,Y) that "stairs" (x,y)
%
% if (x,y) have n points, [X,Y] have 2n-1

% Version 1.0 - January 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[n,m]=size(y);

N=2*n-1;
X=zeros(N,1);
Y=zeros(N,m);

X(1)=x(1);
Y(1,:)=y(1,:);

for i = 2:n
   I=2*(i-1);
   X(I)=(x(i-1)+x(i))/2;
   Y(I,:)=y(i-1,:);
   X(I+1)=X(I);
   Y(I+1,:)=y(i,:);
end
