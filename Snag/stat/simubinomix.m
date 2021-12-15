function [r mu sig f1 mu1 sig1]=simubinomix(N,p,M)

NN=sum(N);
n=length(N)
r=zeros(M,1);

for i = 1:10:M
    ra=0;
    for j = 1:n
        rr=rand(N(j),1);
        ra=ra+length(find(rr<=p(j)));
    end
    r(i:i+9)=ra;
end

mu=mean(r)
sig=std(r)

pp=sum(p.*N)/NN
f1=binopdf(0:NN,NN,pp);
mu1=pp*NN
sig1=sqrt(pp*(1-pp)*NN)
