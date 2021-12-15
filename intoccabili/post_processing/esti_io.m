function [h0 eta psi phi0]=esti_io(hp,hc)
% This function uses signal complex amplitude estimators of the equivalent signal to estimate
% signal parameters
%
% Input:
%   hp,hc: complex amplitude estimators of the equivalent signal
%
% Output:
%   Signal parameter estimations

h0=sqrt(norm(hp)^2+norm(hc)^2);

a=hp/h0;
b=hc/h0;

A=real(a*conj(b));
B=imag(a*conj(b));
C=norm(a)^2-norm(b)^2;

eta=(-1+sqrt(1-4*B^2))/(2*B);
cos4psi=C/sqrt((2*A)^2+C^2);
sin4psi=2*A/sqrt((2*A)^2+C^2);
psi=(atan2(sin4psi,cos4psi)/4)*180/pi;
phi0=angle(hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180))));
