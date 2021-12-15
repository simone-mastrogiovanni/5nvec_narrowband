% bisp_wn

%set_random

figure
g1=gd_noise('gauss','len',10000,'complex')
g1=y_gd(g1);
d1=bispecdx(g1,g1,g1,128,3,64,1);
d1=d1/mean(abs(d1(:)));
image(abs(d1)*30);
figure,semilogy(abs(fft(g1))),grid on

figure
g2=gd_noise('exp','len',10000,'complex')
g2=y_gd(g2);
d2=bispecdx(g2,g2,g2,128,3,64,1);
d2=d2/mean(abs(d2(:)));
image(abs(d2)*30);
figure,semilogy(abs(fft(g2))),grid on

figure
g3=gd_noise('chisq',10,'len',10000,'complex')
g3=y_gd(g3);
d3=bispecdx(g3,g3,g3,128,3,64,1);
d3=d3/mean(abs(d3(:)));
image(abs(d3)*30);
figure,semilogy(abs(fft(g3))),grid on

figure
g4=gd_noise('unif','len',10000,'complex')
g4=y_gd(g4);
d4=bispecdx(g4,g4,g4,128,3,64,1);
d4=d4/mean(abs(d4(:)));
image(abs(d4)*30);
figure,semilogy(abs(fft(g4))),grid on

