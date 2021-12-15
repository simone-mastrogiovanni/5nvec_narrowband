function x=griglia_ret(n1,n2,n3,lcell)
% griglia rettangolare centrata a 0
%
%  n1,n2,n3   numero di celle per ogni dimensione
%  lcell      cell dimension
%  x          [3,n1*n2*n3] posizione dei punti della griglia

n=n1*n2*n3;
x=zeros(3,n);

x1=-(n1-1)/2;
x2=-(n2-1)/2;
x3=-(n3-1)/2;

x(1,:)=x1+floor((0:n-1)/(n2*n3));
x(2,:)=x2+floor(mod((0:n-1)/n3,n2));
x(3,:)=x3+floor(mod((0:n-1),n3));
x=x*lcell;
