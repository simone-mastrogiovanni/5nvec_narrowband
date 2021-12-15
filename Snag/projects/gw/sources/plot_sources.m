function [x,y,h,f]=plot_pssources(sources)

N=length(sources);
x=(1:N);
y=x;
h=x;
f=x;
for i = 1:N
    x(i)=sources(i).a;
    y(i)=sources(i).d;
    h(i)=sources(i).h;
    f(i)=sources(i).f0;
end
fr_max=max(f)
h_max=max(h)
h=h/h_max;
f=ceil(5*f/fr_max);
figure,hold on
axis([0 360 -90 90])
for i = 1:N
    switch f(i)
        case 1
            col='y';
        case 2
            col='r';
        case 3
            col='g';
        case 4
            col='b';
        case 5
            col='k';
    end
    plot(x(i),y(i),'o','MarkerSize',h(i)*10,'MarkerFaceColor',col);
end
grid on