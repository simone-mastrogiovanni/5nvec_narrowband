function [M eta psi histM xhistM]=etapsi_map_old(v5A,v5B,neta,npsi,cont)
% ETAPSI_MAP  creates a  eta/psi quadratic map from 2 base 5-vecs
%
%    [M eta psi histM xhistM]=etapsi_map(v5A,v5B,neta,npsi,cont)
%
%   v5A,v5B     base 5-vecs
%   neta,npsi   number of etas and psis
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

M=zeros(neta,npsi);

deta=2/(neta-1);
eta=-1:deta:1;
dpsi=90/npsi;
psi=(0:npsi-1)*dpsi;
psi0=psi*pi/180;
v=zeros(5,npsi);

for i = 1:neta
    seta=sign(eta(i));
    keta1=sqrt(1/(1+eta(i)^2));
    keta2=sqrt(eta(i)^2/(1+eta(i)^2));
    c1=keta1*cos(2*psi0)-seta*1j*keta2*sin(2*psi0);
    c2=keta1*sin(2*psi0)+seta*1j*keta2*cos(2*psi0);
    for j = 1:5
        v(j,:)=v5A(j)*c1+v5B(j)*c2;
    end
    M(i,:)=sum(abs(v).^2);
end

if nomap == 0
    figure,image(psi,eta,M,'CDataMapping','scaled'),colorbar

    [histM xhistM]=hist(M(:),100);
    figure,hist(M(:),100);

    [x1,y1,z1]=twod_peaks(M,max(M(:))*0.99,1);
    M1=max(M(:))-M;
    [x2,y2,z2]=twod_peaks(M1,max(M1(:))*0.99,1);

    disp(sprintf(' Maximum %f at eta = %f and psi = %f',z1,eta(x1),psi(y1)))
    disp(sprintf(' Minimum %f at eta = %f and psi = %f',max(M(:))-z2,eta(x2),psi(y2)))
end