function g=gd_flatspec2(n,dt)

t=1:n;
g=t*0;
r=rand(1,n/2); 

for i = 0:n/2-1
    fr=i/n;
    g=g+sin((t*fr+r(i+1)-0.5)*2*pi);%figure,plot(sin((t*fr+r(i+1))*2*pi))
end
    
g=gd(g);
g=edit_gd(g,'dx',dt);