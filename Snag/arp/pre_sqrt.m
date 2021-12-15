function y=pre_sqrt(x)
%PRE_SQRT  adjusts data before a square root
%
%         y=pre_sqrt(x)

y=x;

[i,j,v]=find(x<0);

m=size(i);

for k=1:m
   y(i(k),j(k))=0;
end
