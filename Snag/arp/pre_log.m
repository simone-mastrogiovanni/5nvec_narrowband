function y=pre_log(x)
%PRE_LOG  adjusts data before a logarhitm
%
%         y=pre_log(x)

minpos=min(x(find(x>0)));
%minpos=min(find(x>0)); Errato

y=x;

[i,j,v]=find(x<=0);

m=size(i);

for k=1:m
   y(i(k),j(k))=minpos/2;
end
