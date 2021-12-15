function [M1 M2 eta psi]=etapsi_test(v5A,v5B,neta,npsi,cont)
% ETAPSI_TEST  test for eta-psi maps
%
%    [M eta psi histM xhistM]=etapsi_test(v5A,v5B,neta,npsi,cont)
%
%   v5A,v5B     base 5-vecs
%   neta,npsi   number of etas and psis
%   cont        1 -> base vecs +,x
%               2 -> circ L,R
%               <0 -> no map, cont=-cont

% Version 2.0 - August 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nomap=0;
if cont < 0
    cont=-cont;
    nomap=1;
end

M=zeros(neta,npsi);

deta=2/(neta-1);
eta=-1:deta:1;
dpsi=90/npsi;
psi=(0:npsi-1)*dpsi;
psi0=psi*pi/180;
v=zeros(5,npsi);

switch cont
    case 1
        for i = 1:neta
            etai=eta(i);
            for j = 1:npsi
                psi2=psi(j)*pi/90;
                Hp=sqrt(1/(1+etai^2))*(cos(psi2)-1j*etai*sin(psi2));
                Hc=sqrt(1/(1+etai^2))*(sin(psi2)+1j*etai*cos(psi2));
                A=Hp.*v5A+Hc.*v5B;
                M1(i,j)=Hp;
                M2(i,j)=Hc;
            end
        end
    case 2
        for i = 1:neta
            etai=eta(i);
            for j = 1:npsi
                psi2=psi(j)*pi/90;
                HL=(1+etai)*sqrt(0.5/(1+etai^2))*(cos(psi2)-1j*sin(psi2));
                HR=(1-etai)*sqrt(0.5/(1+etai^2))*(cos(psi2)+1j*sin(psi2));
                A=HL.*v5A+HR.*v5B;
                M1(i,j)=HL;
                M2(i,j)=HR;
            end
        end
end

figure,image(psi,eta,abs(M1),'CDataMapping','scaled'),colorbar
figure,image(psi,eta,abs(M2),'CDataMapping','scaled'),colorbar