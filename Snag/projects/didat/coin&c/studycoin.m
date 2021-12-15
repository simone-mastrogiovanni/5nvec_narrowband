function g=studycoin(M,N1,N2,dx1,dx2,win)

ncm=win*0;
teor=ncm;

for i = 1:length(win)
    ncm(i)=coincidmult(M,N1,N2,dx1,dx2,win(i));
    w=win(i)*(dx1+dx2);
    p=N1*w;
    teor(i)=p*N2;
end

figure
plot(win,ncm)
grid on,hold on
plot(win,teor,'r')

figure
loglog(win,ncm)
grid on,hold on
loglog(win,teor,'r')

g=gd(ncm);
g=edit_gd(g,'type',2,'x',win);