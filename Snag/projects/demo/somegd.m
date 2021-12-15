%somegd  creates some gd

g1=gd(1000)
g2=g1
g1=set_gd(g1,'sin');
g2=set_gd(g2,'gauss');

a1=(1:1000);
a1=gd(a1)
a2=a1
a2=a1*a1

c1=gd_chirp
c2=c1
c2=set_gd(c2,'gauss')
c3=c1+10*c2

cc1=gd_worm(c1,'freq',100)

[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);

Z=gd2(Z);
Z=edit_gd2(Z,'ini',-3,'ini2',-4,'dx',0.125,'dx2',0.5/3,'capt','peaks')