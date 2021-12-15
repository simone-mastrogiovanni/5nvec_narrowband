T=10;
N=T*100;
tc=(0:N)*0.01;
ts=(0:T);
fr=1/5;
fr1=1-fr;
figure
plot(tc,sin(2*pi*fr*tc))
hold on
plot(tc,-sin(2*pi*fr1*tc),'r--')
plot(ts,-sin(2*pi*fr1*ts),'ko','MarkerFaceColor',[.49 1 .63])
grid on
title('Aliasing')
xlabel('s')