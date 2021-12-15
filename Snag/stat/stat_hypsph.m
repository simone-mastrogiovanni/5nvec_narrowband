function stat_hypsph(nd,N,nc)
%
%     stat_hypsph(nd,N,nc)
%
%   nd    number of dimensions
%   N     number of points
%   nc    number of components for statistics (1,2)

r=randn(nd,N);
sr=sqrt(sum(abs(r).^2));
for i = 1:nd
    r(i,:)=r(i,:)./sr;
end

rr=randn(nd,N)+1j*randn(nd,N);
sr=sqrt(sum(abs(rr).^2));

for i = 1:nd
    rr(i,:)=rr(i,:)./sr;
end

dx=0.01;
x1=(0:dx:1)+dx/2;
x2=(-1:dx:1);

if nc == 1
    h1=hist(abs(r(1,:)).^2,x1)/(dx*N);

    figure,plot(x1,h1),grid on,title('1-D, real, sq.mod.')
    bet=(nd-1)*(1-x1).^(nd-2);
    bet=bet.^2;
    hold on,plot(x1,bet,'r')

    h1=hist(r(1,:),x2)/(dx*N);
    figure,plot(x2,h1),grid on,title('1-D, real')
    dist=betapdf((x2+1)/2,(nd-1)/2,(nd-1)/2)/2;
    hold on,plot(x2,dist,'r')

    h1=hist(abs(rr(1,:)).^2,x1)/(dx*N);

    figure,plot(x1,h1),grid on,title('1-D, complex, sq.mod.')
    bet=(nd-1)*(1-x1).^(nd-2);
    hold on,plot(x1,bet,'r')

    h1=hist(real(rr(1,:)),x2)/(dx*N);

    figure,plot(x2,h1),grid on,title('1-D, complex, real part')
    dist=betapdf((x2+1)/2,nd-0.5,nd-0.5)/2;
    hold on,plot(x2,dist,'r')
else
    h1=hist(abs(r(1,:)).^2+abs(r(2,:)).^2,x1)/(dx*N);

    figure,plot(x1,h1),grid on,title('2-D, real, sq.mod.')
    bet=(nd-1)*(1-x1).^(nd-2);
    bet=bet.^2;
    hold on,plot(x1,bet,'r')

    h1=hist(r(1,:).*r(2,:),x2)/(dx*N);
    figure,plot(x2,h1),grid on,title('2-D, real, corr.')
    dist=betapdf((x2+1)/2,(nd-1)/2,(nd-1)/2)/2;
    hold on,plot(x2,dist,'r')

    h1=hist(abs(rr(1,:)).^2+abs(rr(2,:)).^2,x1)/(dx*N);

    figure,plot(x1,h1),grid on,title('2-D, complex, sq.mod.')
    bet=(nd-1)*(1-x1).^(nd-2);
    hold on,plot(x1,bet,'r')
    
    h1=hist(real(rr(1,:)).*imag(rr(1,:)),x2)/(dx*N);

    figure,plot(x2,h1),grid on,title('2-D, complex, corr 1r*1i')
    dist=betapdf((x2+1)/2,nd-0.5,nd-0.5)/2;
    hold on,plot(x2,dist,'r')

    h1=hist(real(rr(1,:)).*imag(rr(2,:)),x2)/(dx*N);

    figure,plot(x2,h1),grid on,title('2-D, complex, corr 1r*2i')
    dist=betapdf((x2+1)/2,nd-0.5,nd-0.5)/2;
    hold on,plot(x2,dist,'r')

    h1=hist(real(rr(1,:).*rr(2,:)),x2)/(dx*N);

    figure,plot(x2,h1),grid on,title('2-D, complex, corr real(1*2)')
    dist=betapdf((x2+1)/2,nd-0.5,nd-0.5)/2;
    hold on,plot(x2,dist,'r')
end
    