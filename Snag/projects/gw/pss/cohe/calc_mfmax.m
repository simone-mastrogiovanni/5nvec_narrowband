function [a b m2max]=calc_mfmax(L0,L45,m0,m45,verb)
% CALC_MFMAX  computes the 4dof max mf
%
%    L0,L45   base 5-vect
%    m0,m45   mfs for plus and cross

A0_2=norm(L0)^2;
A45_2=norm(L45)^2;
k=1/sqrt((A0_2*abs(m0))^2+(A45_2*abs(m45))^2);

a=k*A0_2*m0;
b=k*A45_2*m45;

den=abs(a)^2*A0_2+abs(b)^2*A45_2;
D=(A0_2^3*abs(m0)^2+A45_2^3*abs(m45)^2)/(A0_2^2*abs(m0)^2+A45_2^2*abs(m45)^2);
m2max=abs((A0_2*conj(a)*m0+A45_2*conj(b)*m45)/den)^2;
m2max1=(A0_2^2*abs(m0)^2+A45_2^2*abs(m45)^2)/den^2;

if verb > 0
    fprintf('Check: a^2+b^2, den, D : %f %f %f \n',abs(a)^2+abs(b)^2,den,D)
    fprintf('Check: m2max, m2max1 : %f %f \n',m2max,m2max1)
    [eta psi]=ab2etapsi(a,b);
    fprintf('Check: eta, psi : %f %f \n',eta,psi);
end