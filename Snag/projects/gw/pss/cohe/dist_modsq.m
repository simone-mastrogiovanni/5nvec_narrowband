function [d,d1,d2]=dist_modsq(sour,ant)
% DIST_MODSQ  computes the distribution of the square modulus of a 5-vect
%             of signal
%
%    [d,d1,d2]=dist_modsq(sour,ant)
%
%   sour,ant  source and antenna structures
%
%   d,d1,d2   gds with distributions for for the signal and the two basic components

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N=1000000;
[L0 L45 CL CR V Hp Hc]=sour_ant_2_5vec(sour,ant);

out=rand_point_on_sphere(N);

psi=out(:,1)*pi/720;
eta=sin(out(:,2)*pi/180);

H1=(cos(2*psi)-1j*eta.*sin(2*psi))./sqrt(1+eta.^2);
H2=(sin(2*psi)+1j*eta.*cos(2*psi))./sqrt(1+eta.^2);

a1=eta*0;
a2=a1;
a=a1;

for i = 1:5
    a1=a1+abs(L0(i)*H1).^2;
    a2=a2+abs(L45(i)*H2).^2;
end

a=a1+a2;
m1=min(min(a1),min(a1));
m2=max(a);
dx=(m2-m1)/199;
x=m1+(0:199)*dx;
d1=hist(a1,x)/(N*dx);
d2=hist(a2,x)/(N*dx);
d=hist(a,x)/(N*dx);

figure,plot(x,d),hold on,grid on,plot(x,d1,'r'),plot(x,d2,'g')
title('distribution of  |A|^2  |A_+|^2  |A_x|^2   (b,r,g)')

d=gd(d);
d=edit_gd(d,'ini',m1,'dx',dx);
d1=gd(d1);
d1=edit_gd(d1,'ini',m1,'dx',dx);
d2=gd(d2);
d2=edit_gd(d2,'ini',m1,'dx',dx);

% figure,plot(abs(H1),abs(H2),'.')