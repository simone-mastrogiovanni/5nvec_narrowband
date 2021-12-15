function data=ana_polyerr(data)
%  ana_polyerr for use with data_polyfit
%  

N=100;
y1=data.y+data.res;
x=data.x;
n=length(y1);
sig=std(data.res);
deg=length(data.a)-1;
unc=data.unc;
a=zeros(N,deg+1);

for i = 1:N
    y2=y1+randn(n,1)*sig;
    [a(i,:),covar,F,res,chiq,ndof,err,errel]=gen_lin_fit(x,y2,unc,1,deg,0);
end

data.a1=mean(a);
data.aunc1=std(a);
data.renaunc=data.aunc*sig/unc;