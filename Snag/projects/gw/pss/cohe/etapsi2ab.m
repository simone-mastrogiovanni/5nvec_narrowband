function [a b]=etapsi2ab(eta,psi)

k=1/sqrt(1+eta^2);
c2p=cos(2*psi*pi/180);
s2p=sin(2*psi*pi/180);

a=k*(c2p-1j*eta*s2p);
b=k*(s2p+1j*eta*c2p);
