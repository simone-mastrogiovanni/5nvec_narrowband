function m=ns_2lev(nA,np)

p=(0:(np-1))/(np-1);
A=(0:(nA-1))/(nA-1);
m=zeros(nA,np);p,A

for i=1:np
    for j=1:nA
        m(j,i)=sqrt(p(i)+(A(j).^2).*(1-p(i)))./(p(i)+A(j).*(1-p(i))+0.000001)-1+.000001;
        %disp(sprintf(' %f %f %f',p(i),A(j),m(j,i)))
    end
end

m(1,1)=0;