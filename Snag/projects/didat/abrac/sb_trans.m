function y=sb_trans(p,absst,x)
%
%  p       trans prob
%  absst   absorbing states; [] m-> no
%  x       input distribution

nn=length(x);
nn2=nn/2;
n=log2(nn);
m=length(absst);

if n ~= floor(n)
    disp('x non ha lunghezza potenza di 2')
    len=nn
    return
end

y(1:2:nn)=(1-p)*x(1:nn2);
y(2:2:nn)=p*x(1:nn2);
y(1:2:nn)=y(1:2:nn)+(1-p)*x(nn2+1:nn);
y(2:2:nn)=y(2:2:nn)+p*x(nn2+1:nn);

for i = 1:m
    st=absst(i);
    st1=mod(st*2,nn);
    st=st+1;
    st1=st1+1;
    y(st1)=y(st1)-(1-p)*x(st);
    y(st1+1)=y(st1+1)-p*x(st);
    y(st)=y(st)+x(st);
end
    