N=1000;
eps=0.2;
i=1:N;
x=cos(2*pi*i/N);
y=sin(2*pi*i/N);
c=x+j*y;
figure
plot(x,y)
axis([-2 2 -2 2])
set(gca,'DataAspectRatio',[1 1 1])

% rotazione
pervib=1000000;
perrot=50;

for i = 1:100
    e=eps*cos(2*pi*i/pervib);
    c=x*(1-e)+j*y*(1+e);
    c=c*exp(-j*2*pi*i/perrot);
    plot(real(c),imag(c)),hold on
    c1=[(1-e) -(1-e)]+j*[0 -0];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'r')
    c1=[0 -0]+j*[(1+e) -(1+e)];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'g')
    axis([-2 2 -2 2]),
%     title('rotation')
    set(gca,'DataAspectRatio',[1 1 1])
    F(i)=getframe;
    hold off
end

% vibrazione
pervib=50;
perrot=1000000;

for i = 1:100
    e=eps*cos(2*pi*i/pervib);
    c=x*(1-e)+j*y*(1+e);
    c=c*exp(-j*2*pi*i/perrot);
    plot(real(c),imag(c)),hold on
    c1=[(1-e) -(1-e)]+j*[0 -0];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'r')
    c1=[0 -0]+j*[(1+e) -(1+e)];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'g')
%     title('vibration'),
    axis([-2 2 -2 2])
    set(gca,'DataAspectRatio',[1 1 1])
    F1(i)=getframe;
    hold off
end


% falsa vibrazione
pervib=50;
perrot=1000000;

for i = 1:100
    e=eps*cos(2*pi*i/pervib);
    e1=(1+eps)*sin(pi*i/pervib);
    e2=(1-eps)*cos(pi*i/pervib);
    c=x*(1-e)+j*y;
    c=c*exp(-j*2*pi*i/perrot);
    plot(real(c),imag(c)),hold on
    c1=[e1 -e1]+j*[0 -0];
    plot(real(c1),imag(c1),'r')
    c1=[e2 -e2]+j*[0.01 0.01];
    plot(real(c1),imag(c1),'g')
%     c1=[0 -0]+j*[(1) -(1)];
%     c1=c1*exp(-j*2*pi*i/perrot);
%     plot(real(c1),imag(c1),'g')
    axis([-2 2 -2 2])
    set(gca,'DataAspectRatio',[1 1 1])
    F1a(i)=getframe;
    hold off
end

% roto-vibrazione
pervib=20;
perrot=50;

for i = 1:100
    e=eps*cos(2*pi*i/pervib);
    c=x*(1-e)+j*y*(1+e);
    c=c*exp(-j*2*pi*i/perrot);
    plot(real(c),imag(c)),hold on
    c1=[(1-e) -(1-e)]+j*[0 -0];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'r')
    c1=[0 -0]+j*[(1+e) -(1+e)];
    c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'g')
%     title('roto-vibration'),
    axis([-2 2 -2 2])
    set(gca,'DataAspectRatio',[1 1 1])
    F2(i)=getframe;
    hold off
end

% hola
pervib=1000000;
perrot=50;

for i = 1:100
    e=eps*cos(2*pi*i/pervib);
    c=x*(1-e)+j*y*(1+e);
    c=c*exp(-j*2*pi*i/perrot);
    plot(real(c),imag(c)),hold on
    [a ii]=min(abs(imag(c)));
    c1=[real(c(ii)) -real(c(ii))]+j*[0 -0];
%     c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'r')
    [a ii]=min(abs(real(c)));
    c1=[0 -0]+j*[imag(c(ii)) -imag(c(ii))];
%     c1=c1*exp(-j*2*pi*i/perrot);
    plot(real(c1),imag(c1),'g')
    axis([-2 2 -2 2]),
%     title('rotation')
    set(gca,'DataAspectRatio',[1 1 1])
    F3(i)=getframe;
    hold off
end

movie(F,2)
movie(F1,2)
movie(F1a,2)
movie(F2,2)
movie(F3,2)