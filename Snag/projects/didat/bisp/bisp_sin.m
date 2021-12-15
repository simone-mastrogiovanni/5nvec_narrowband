% bisp_sin

fr=0.9;

figure
g1=exp(j*(1:10000)*fr);
d1=bispecdx(g1,g1,g1,1024,3,512,1);
d1=d1/mean(abs(d1(:)));
image(abs(d1)*10);
figure, plot(g1)
figure,semilogy(abs(fft(g1))),grid on

figure
g1=sin((1:10000)*fr);
d1=bispecdx(g1,g1,g1,1024,3,512,1);
d1=d1/mean(abs(d1(:)));
image(abs(d1)*10);
figure, plot(g1)
figure,semilogy(abs(fft(g1))),grid on

figure
g2=g1.^3;
d1=bispecdx(g2,g2,g2,1024,3,512,1);
d1=d1/mean(abs(d1(:)));
image(abs(d1)*10);
figure, plot(g1)
figure,semilogy(abs(fft(g2))),grid on

figure
g3=g1.^3+0.2*g1.^2;
d1=bispecdx(g3,g3,g3,1024,3,512,1);
d1=d1/mean(abs(d1(:)));
image(abs(d1)*10);
figure, plot(g1)
figure,semilogy(abs(fft(g3))),grid on