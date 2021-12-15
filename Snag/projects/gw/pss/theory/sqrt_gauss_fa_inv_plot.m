% sqrt_gauss_fa_inv_plot

NN=40;
p=0.5*10.^-(0:0.01:NN);
figure,semilogx(p,sqrt(gauss_fa_inv(p))),grid
set(gca,'XDir','reverse')
axis tight