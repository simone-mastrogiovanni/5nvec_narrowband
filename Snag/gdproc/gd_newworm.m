function w=gd_newworm(g,fr)

y=y_gd(g);
x=x_gd(g)*fr*2*pi;

w=y.*exp(-1i*x);

