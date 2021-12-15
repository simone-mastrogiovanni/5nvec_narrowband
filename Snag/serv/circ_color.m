function out=circ_color(a,b)

n=300;
N=6*n;
n255=255;

ir=zeros(1,N);
ig=ir;
ib=ir;

aa=(0:N-1)*2*pi/N;
ca=cos(aa);
sa=sin(aa);

ir(1:n)=n255;
ir(n+1:2*n)=(n:-1:1)*n255/n;
ir(4*n+1:5*n)=(1:n)*n255/n;
ir(5*n+1:N)=n255;

ig(1:n)=(1:n)*n255/n;
ig(n+1:3*n)=n255;
ig(3*n+1:4*n)=(n:-1:1)*n255/n;

ib(2*n+1:3*n)=(1:n)*n255/n;
ib(3*n+1:5*n)=n255;
ib(5*n+1:N)=(n:-1:1)*n255/n;

out.ir=ir/n255;
out.ig=ig/n255;
out.ib=ib/n255;

figure,hold on

for i = 1:N
    plot([ca(i) 2*ca(i)],[sa(i) 2*sa(i)],'color',[out.ir(i),out.ig(i),out.ib(i)])
end
title('colori puri')

figure,hold on

for i = 1:N
    plot([ca(i) 2*ca(i)],[sa(i) 2*sa(i)],'color',[out.ir(i),out.ig(i),out.ib(i)]*a+b)
end

figure,hold on

for i = 1:N
    plot([ca(i) 2*ca(i)],[sa(i) 2*sa(i)],'color',[out.ir(i),out.ig(i),out.ib(i)])
    plot([0 ca(i)],[0 sa(i)],'color',[out.ir(i),out.ig(i),out.ib(i)]*a+b)
end