function [eta psi]=ab2etapsi(a,b)

ab=sqrt(abs(a)^2+abs(b)^2);
a=a/ab;
b=b/ab;

ab=a*conj(b);
A=real(ab);
B=imag(ab);
C=abs(a)^2-abs(b)^2;

eta=(-1+sqrt(1-4*B^2))/(2*B);
psi=atan2(2*A,C)*45/pi;
