% did_analyt

n=2000;
om=0.1;
asim=0;
x=zeros(n,1);
x=x(:);
gauss=exp(-(((1:n)-n/2).^2)/(2*(n/10).^2));
dgauss=diff(gauss);
gauss=gauss/max(gauss);
dgauss=dgauss/max(dgauss);

x=(gauss(1:length(dgauss))+dgauss*asim).*sin(om*(1:length(dgauss)));
out=gd_anasig(x);

figure,plot(x);
hold on
plot(imag(out),'g--')
plot(abs(out),'r')

    
    