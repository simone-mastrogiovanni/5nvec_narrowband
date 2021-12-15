function g=multi_exp(w,x,typ)
%MULTI_EXP  multi-exponential distribution function
%
%   w    exponential means
%   x    x values
%  typ   1 -> density, 2 -> cumulative, 3 -> threshold
%
%   g    output gd

n=length(w);
w=sort(w);
var=1;

for i = 2:n
    if w(i) == w(i-1)
        w(i-1)=w(i)*(1+0.001*var);
        var=var+1;
    end
end

mut=sum(w);
vart=sum(w.^2);
Nt=2*mut*mut/vart;
s=sprintf('theoretic mu,ds,N : %f %f %f',mut,sqrt(vart),Nt);
disp(s)

A=zeros(1,n);

for i = 1:n
    A(i)=w(i).^(n-2);
    for j = 1:n
        if i ~= j
            A(i)=A(i)/(w(i)-w(j));
        end
    end
end

switch typ 
    case 1
        g=0;
        for i = 1:n
            g=g+A(i)*exp(-x/w(i));
        end 
        uni=0;mu=0;q=0;
        m=length(x);
        ex=0;
        for i=1:m
            uni=uni+g(i)*(x(i)-ex);
            mu=mu+g(i)*x(i)*(x(i)-ex);
            ex=x(i);
        end
        ex=0;
        q3=0;q4=0;
        for i=1:m
            q=q+g(i)*(x(i)-mu)^2*(x(i)-ex);
            q3=q3+g(i)*(x(i)-mu)^3*(x(i)-ex);
            q4=q4+g(i)*(x(i)-mu)^4*(x(i)-ex);
            ex=x(i);
        end
        
        sigma=sqrt(q);
        N=2*mu*mu/(sigma*sigma);
        s=sprintf('effective mu,ds,N,mu3,mu4,sk,cu : %f %f %f %f %f %f %f',...
            mu,sigma,N,q3,q4,q3/sigma^3,q4/sigma^4);
        disp(s)
        uni
    case 2
        g=0;
        for i = 1:n
            g=g+A(i)*w(i)*exp(-x/w(i));
        end 
        g=1-g;
    case 3
        g=0;
        for i = 1:n
            g=g+A(i)*w(i)*exp(-x/w(i));
        end
end

g=gd(g);
g=edit_gd(g,'capt','Multi-exponential','x',x,'type',2);