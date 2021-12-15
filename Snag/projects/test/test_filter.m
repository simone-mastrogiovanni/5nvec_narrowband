x=randn(1,100000);

w=0.999;
a(1)=1;
a(2)=-w;
b(1)=1;
zi=0;

for j = 1:100
    [y,zi]=filter(b,a,x,zi);
end

yy=zeros(1,100000);

zzi=0;

for j = 1:100
    for i = 1:100000
        yy(i)=x(i)+w*zzi;
        zzi=yy(i);
    end
end

y(100000),yy(100000)