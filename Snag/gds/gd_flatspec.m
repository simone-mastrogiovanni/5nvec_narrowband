function g=gd_flatspec(n,dt)

g=rand(1,n/2+1)-0.5+j*(rand(1,n/2+1)-0.5);
g(n/2+1)=real(g(n/2+1));
g(n/2+2:n)=conj(g(n/2:-1:2));
g=g./abs(g); % figure,plot(g,'.'),figure,plot(abs(g))
g(1)=1;
g=ifft(g)*sqrt(n);

g=gd(g);
g=edit_gd(g,'dx',dt);