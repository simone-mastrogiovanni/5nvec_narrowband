% test_sin

clear

N=1000000;
omdt=0.0123453;

j=0:N-1;
x=j*omdt;

y1=sin(x);

y0=exp(1.0i*omdt);
% y2=y0.^j;

% y3(1)=y0;
% for j = 2:N
%     y3(j)=y3(j-1)*y0;
% end

b=1;
a(1)=1;a(2)=-y0;
x=x*0;
x(1)=y0;
y4=filter(b,a,x);