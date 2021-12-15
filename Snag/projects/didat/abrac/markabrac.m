function [r A b pp mu]=markabrac(n,p,N,stopst)
%
%   n      lunghezza stato
%   p      prob 1
%   N      numero ritardi (def o 0 -> 10*2^n)
%   stops  numero dello stato target (def 2^n-1)

nn=2^n;
nn2=nn/2;
mu=zeros(1,nn);
if ~exist('N','var') || N==0
    N=10*2^n;
end
if ~exist('stopst','var')
    stopst=0:2^n-1;
end

for ii = 1:nn
    str=dec2base(ii-1,2);
    cc=sum(sign(sscanf(str,'%1d')));
    b0(ii)=p^cc*(1-p)^(n-cc);
end

pp0=p^n;
fprintf('  Tempo di attesa medio: %f \n\n',1/pp0);
   
ns=length(stopst);
figure

for k = 1:ns
    A=zeros(nn,nn);
    for i = 1:nn2
        A(i,2*i-1)=1-p;
        A(i,2*i)=p;
        A(i+nn2,2*i-1)=1-p;
        A(i+nn2,2*i)=p;
    end
    n0=stopst(k)+1;

    if stopst(k) < nn2
        A(n0,n0*2)=0;
        A(n0,n0*2-1)=0;
    else
        n00=n0-nn2;
        A(n0,n00*2)=0;
        A(n0,n00*2-1)=0;
    end
    A(n0,n0)=1;

    r=zeros(1,N);

    b=b0;
    b(n0)=0;

    for i = 1:N;
        bb=b*A^i;
        r(i)=bb(n0);
    end

    pp(2:length(r))=diff(r);
    pp(1)=r(1);
%     pp(1)=0;
    semilogy(pp,'color',rotcol(k+1)),hold on,semilogy(pp,'.','color',rotcol(k))
    mu(k)=sum((1:N).*pp)+1;
    str=dec2bin(stopst(k),n);
    fprintf('%3d %s %f \n',stopst(k),str,mu(k));
end

grid on
if ns == 1
    figure,plot(r),hold on,plot(r,'r.'),grid on
else
    figure,plot(0:nn-1,mu),hold on,plot(0:nn-1,mu,'r.'),grid on
end
