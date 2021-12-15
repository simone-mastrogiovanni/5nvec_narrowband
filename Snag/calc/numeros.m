function [num,item]=numeros(in)
% NUMEROS  computes the numerosity of items

in=sort(in);
dd=diff(in);
n=length(in);
d=zeros(1,n);
d(1)=1;
d(2:n)=dd;

[i1,i2,i3]=find(d);
nout=length(i1);
num=diff(i2);
num(length(num)+1)=n-i2(nout)+1;
item=in(i2);

