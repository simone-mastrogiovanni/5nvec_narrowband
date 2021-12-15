function [pp w]=sb_stevol(n,p,stat)

A=sb_creamat(n,p);
A=sparse(A);
nn=2^n;
nn2=nn/2;
if ~exist('stat','var')
    stat=0:nn-1;
end

b0=zeros(1,nn);
m=length(stat);
pp=zeros(m,n);

C=cell(1,n);
for i = 1:n
    C{i}=A^i;
end

for ii = 1:m
    st0=stat(ii)+1;
    b=b0;
    b(st0)=1;
    for i = 1:n
        c=b*C{i};
        pp(ii,i)=c(st0);
    end
    pp(ii,:)=pp(ii,:)-pp(ii,n);
    w(ii)=(sum(pp(ii,:))+1);
end

w=w*nn;
figure,plot(pp')
figure,plot(w)