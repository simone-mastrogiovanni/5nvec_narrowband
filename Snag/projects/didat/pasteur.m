%pasteur

dx=.1;
zzmax=2;
x=-10:dx:10;
y=-10:dx:10;
[X,Y]=meshgrid(x,y);
zz=sqrt(X.^2+Y.^2);
[i,j]=find(zz<zzmax);
ij=length(i);
for ij = 1:ij
    zz(i(ij),j(ij))=zzmax;
end
z=-1./zz;
figure
surf(X,Y,z,'FaceColor','blue','EdgeColor','none')
camlight left; lighting phong

g=-1./abs(x);
figure
plot(x,g,'b')
grid on, hold on
plot([0 0],[-10 1],'k')
plot([-2 0],[0 -2],'r')
plot([-1 0],[-1 -1],':g')

