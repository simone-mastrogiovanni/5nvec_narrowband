function [g I M0 x0 r]=exfun_lm_uncert(Ix,Mb,lb,b,M1,r1,r2,h,T0)
% pend_nobloc  da usare per lm_uncert

x0=lb-(lb/2-b)-h/2;
I=Ix+(Mb.*lb.^2)/12+Mb.*b.^2+(M1/12).*(3*(r1.^2+r2.^2)+h.^2)+M1.*x0.^2;
M0=Mb+M1;
r=(Mb.*b+M1.*x0)./(M1+Mb);
g=4*pi.^2.*I./(T0.^2.*M0.*r);