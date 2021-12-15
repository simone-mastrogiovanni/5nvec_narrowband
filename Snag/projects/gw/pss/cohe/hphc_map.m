function [M hp phi histM xhistM]=hphc_map(v5A,v5B,nhp,nphi,cont)
% HPHC_MAP  creates a Hp/phi quadratic map from 2 base 5-vecs
%
%    [M eta psi histM xhistM]=etapsi_map(v5A,v5B,nhp,nphi,cont)
%
%   v5A,v5B     base 5-vecs
%   nhp,nphi    number of Hp and phi
%   cont        1 -> base vecs +,x
%               2 -> circ L,R
%               <0 -> no map, cont=-cont

% Version 2.0 - July 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nomap=0;
if cont < 0
    cont=-cont;
    nomap=1;
end

M=zeros(nhp,nphi);

dhp=1/(nhp-1);
hp=0:dhp:1;
dphi=180/nphi;
phi=(0:nphi-1)*dphi;
phi0=phi*pi/180;
v=zeros(5,nphi);

for i = 1:nhp
    c1=hp(i);
    c2=sqrt(1-c1.^2)*exp(1j*2*phi0);
    for j = 1:5
        v(j,:)=v5A(j)*c1+v5B(j)*c2;
    end
    M(i,:)=sum(abs(v).^2);
end

if nomap == 0
    figure,image(phi,hp,M,'CDataMapping','scaled'),colorbar

    [histM xhistM]=hist(M(:),100);
    figure,hist(M(:),100);

    [x1,y1,z1]=twod_peaks(M,max(M(:))*0.99,1);
    M1=max(M(:))-M;
    [x2,y2,z2]=twod_peaks(M1,max(M1(:))*0.99,1);

    disp(sprintf(' Maximum %f at eta = %f and psi = %f',z1,hp(x1),phi(y1)))
    disp(sprintf(' Minimum %f at eta = %f and psi = %f',max(M(:))-z2,hp(x2),phi(y2)))
end