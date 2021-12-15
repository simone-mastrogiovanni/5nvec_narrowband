function [pp w]=sb_t_stevol(n,p,stat)

nn=2^n;
nn2=nn/2;
if ~exist('stat','var')
    stat=0:nn-1;
end
b0=zeros(1,nn);
m=length(stat);
pp=zeros(m,n);

for ii = 1:m
    st0=stat(ii)+1;
    x=b0;
    x(st0)=1;
    for i = 1:n
        x=sb_trans(p,[],x);
        pp(ii,i)=x(st0);
    end
    pp(ii,:)=pp(ii,:)-pp(ii,n);
    w(ii)=(sum(pp(ii,:))+1);
end

w=w*nn;
figure,plot(pp')
figure,plot(w)