function x=griglia_circ(n,lcell)
% griglia circolare centrata a 0
%
%  n      numero di celle nel diametro
%  lcell  cell dimension
%  x      [3,n] posizione dei punti della griglia

nn=n^3;
r=lcell*(n-1)/2;
x=zeros(3,nn);

x1=-(n-1)/2;

x(1,:)=x1+floor((0:nn-1)/(n^2));
x(2,:)=x1+floor(mod((0:nn-1)/n,n));
x(3,:)=x1+floor(mod((0:nn-1),n));

x=x*lcell;

xx=sqrt(x(1,:).^2+x(2,:).^2+x(3,:).^2)-0.000001;
i=find(xx <= r);
x=x(:,i);
