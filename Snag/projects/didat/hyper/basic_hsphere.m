function basic_hsphere(nmax)

n=1:nmax;

Vn=pi.^(n/2)./gamma(n/2+1);
figure,semilogy(Vn,'b.'),grid on

An=2*pi.^(n/2)./gamma(n/2);
hold on,semilogy(An,'r.'),grid on
title('Volume (blue) and Area (red)')

figure,plot((An./Vn)./n,'.'),grid on

figure,plot(An(2:nmax)./Vn(1:nmax-1),'g.'),grid on
title('Ratio Area/Volume same dimensions')

a=sqrt(2*pi*(n+1/2));
figure,plot((An(2:nmax)./Vn(1:nmax-1))./a(1:nmax-1),'g.'),grid on
title('(Area/Volume)^2 same dimensions')

figure,plot(((An(2:nmax)./Vn(1:nmax-1)).^2)./((1:nmax-1)+2/pi),'r.'),grid on
title('((Area/Volume)^2)/n same dimensions')

figure,plot(An(3:nmax)./Vn(1:nmax-2),'.'),grid on
title('Ratio Area(n+2)/Volume(n) ')
