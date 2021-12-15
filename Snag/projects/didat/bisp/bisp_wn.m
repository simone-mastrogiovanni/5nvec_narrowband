% bisp_wn

%set_random

figure
g1=gd_noise('gauss','len',10000)
g1=y_gd(g1);
g1=g1/std(g1);
d1=bispecdx(g1,g1,g1,128,3,64,1);disp([std(g1(:)) mean(abs(d1(:)))])
d1=d1/mean(abs(d1(:)));
image(abs(d1)*30);
dd1=log(abs(d1));
fdd1=abs(fft2(dd1));m1=mean(fdd1(:))
figure,image(fdd1*50/m1)

figure
g2=gd_noise('exp','len',10000)
g2=y_gd(g2);
g2=g2/std(g2);
d2=bispecdx(g2,g2,g2,128,3,64,1);disp([std(g2(:))  mean(abs(d2(:)))])
d2=d2/mean(abs(d2(:)));
image(abs(d2)*30);
dd1=log(abs(d2));
fdd2=abs(fft2(dd1));m2=mean(fdd2(:))
figure,image(fdd2*50/m1)

figure
g3=gd_noise('chisq',10,'len',10000)
g3=y_gd(g3);
g3=g3/std(g3);
d3=bispecdx(g3,g3,g3,128,3,64,1);disp([std(g3(:))  mean(abs(d3(:)))])
d3=d3/mean(abs(d3(:)));
image(abs(d3)*30);
dd1=log(abs(d3));
fdd3=abs(fft2(dd1));m3=mean(fdd3(:))
figure,image(fdd3*50/m1)

figure
g4=gd_noise('unif','len',10000)
g4=y_gd(g4);
g4=g4/std(g4);
d4=bispecdx(g4,g4,g4,128,3,64,1);disp([std(g4(:)) mean(abs(d4(:).^2))])
d4=d4/mean(abs(d4(:)));
image(abs(d4)*30);
dd1=log(abs(d4));
fdd4=abs(fft2(dd1));m4=mean(fdd4(:))
figure,image(fdd4*50/m1)
