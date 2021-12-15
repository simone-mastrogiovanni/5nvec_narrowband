function sp=sp_house(n)

sp=zeros(1,n);
k=floor(n/200);
 
sp(20*k+1:40*k)=10+0.5*(1:20*k)/k;
sp(40*k+1:60*k)=20-0.5*(0:20*k-1)/k;

sp(50*k:55*k)=17.6;

for i = 2:n/2
    sp(n+2-i)=sp(i);
end
sp=sp.*sp;

sp=gd(sp);