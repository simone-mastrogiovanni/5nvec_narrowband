% driver_exfun_lm_uncert

Ix=[42.1 2.6 0];
Mb=[27.23 0.01 1];
lb=[38.10 0.01 1];
b=[16.50 0.01 1];
M1=[75.51 0.01 1];
r1=[0.79/2 0.01 1];
r2=[2.53/2 0.01 1];
h=[2.025 0.010 1];
T0=[1.1545 0.0002 0];

[unc2 yhist2 yphist2]=lm_uncert(@exfun_lm_uncert,Ix,Mb,lb,b,M1,r1,r2,h,T0)

[g I M0 x0 r]=exfun_lm_uncert(Ix(1),Mb(1),lb(1),b(1),M1(1),r1(1),r2(1),h(1),T0(1))