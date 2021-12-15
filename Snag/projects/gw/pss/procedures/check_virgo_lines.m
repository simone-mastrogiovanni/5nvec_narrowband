% check_virgo_lines

f1=384;
f2=f1*1.5;
f3=f1*2.5;
f4=f1*3.5;

h0=10^-19;
nu=4000;
t=0:399999;

h=h0*(sin(f1*2*pi*t/nu)+sin(f2*2*pi*t/nu)+sin(f3*2*pi*t/nu)+sin(f4*2*pi*t/nu));

h=gd(h);
h=edit_gd(h,'dx',1/nu);

hs=gd_pows(h,'pieces',10);

hs=sqrt(hs*2);

figure
semilogy(SensitivityH_WSR9,hs,'r'),grid on