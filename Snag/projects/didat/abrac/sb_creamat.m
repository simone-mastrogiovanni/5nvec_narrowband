function A=sb_creamat(n,p)

nn=2^n;
nn2=nn/2;

A=zeros(nn,nn);
for i = 1:nn2
    A(i,2*i-1)=1-p;
    A(i,2*i)=p;
    A(i+nn2,2*i-1)=1-p;
    A(i+nn2,2*i)=p;
end