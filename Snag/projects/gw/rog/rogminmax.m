M=50000;
n=8;
j=0;
sog=0.5;
mima=zeros(1,M);

for i = 1:M
    x=(randn(n,1).^2+randn(n,1).^2)./2;
    minx=min(x);
    maxx=max(x);
    if minx > sog
        j=j+1;
        mima(j)=maxx/minx; %sprintf(' %f , %f : %f',minx,maxx,mima(j))
    end
end

mima=mima(1:j);
mean(mima),std(mima)
mi=min(mima);
ma=max(mima);
Num=j

figure
x=((0:49)*(ma-mi)/50+mi);
m=hist(mima,x)/Num;
plot(x,m);grid on;