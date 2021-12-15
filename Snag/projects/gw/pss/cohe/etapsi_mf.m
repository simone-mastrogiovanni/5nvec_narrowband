function [etamax psimax a2max M eta psi C histM xhistM]=etapsi_mf(dat5,v5A,v5B,neta,npsi,cont,verb)
% ETAPSI_MF  creates eta/psi 4-dof mf and coherence maps from 2 base 5-vecs
%
%    [M eta psi C histM xhistM]=etapsi_mf(dat5,v5A,v5B,neta,npsi,cont,verb)
%
%   dat5        data 5-vec
%   v5A,v5B     base 5-vecs
%   neta,npsi   number of etas and psis
%   cont        1 -> base vecs +,x
%               2 -> circ L,R
%   verb        verbosity (def=1)
%
%   M           MF matrix
%   C           Coherence matrix

% Version 2.0 - July 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('verb','var')
    verb=1;
end

M=zeros(neta,npsi);
C=M;

deta=2/(neta-1);
eta=-1:deta:1;
dpsi=90/npsi;
psi=(0:npsi-1)*dpsi;
psi0=psi*pi/180;
v=zeros(5,npsi);
maxM=0;

normdat5=norm(dat5);

switch cont
    case 1
        for i = 1:neta
            etai=eta(i);
            for j = 1:npsi
                psi2=psi(j)*pi/90;
                Hp=sqrt(1/(1+etai^2))*(cos(psi2)-1j*etai*sin(psi2));
                Hc=sqrt(1/(1+etai^2))*(sin(psi2)+1j*etai*cos(psi2));
                A=Hp.*v5A+Hc.*v5B;
                mf=mf_5vec(dat5,A);
                M(i,j)=abs(mf).^2;
                C(i,j)=(norm(mf*A)/normdat5)^2;
                if M(i,j) > maxM
                    maxM=M(i,j);
                    mfA=mf_5vec(dat5,v5A);
                    mfB=mf_5vec(dat5,v5B);
                    maxMA=abs(mfA).^2;
                    maxMB=abs(mfB).^2;
                    maxC=C(i,j);
                    maxCA=(norm(mfA*v5A)/normdat5)^2;
                    maxCB=(norm(mfB*v5B)/normdat5)^2;
                end
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
                mf=mf_5vec(dat5,A);
                M(i,j)=abs(mf).^2;
                C(i,j)=(norm(mf*A)/normdat5)^2;
                if M(i,j) > maxM
                    maxM=M(i,j);
                    mfA=mf_5vec(dat5,v5A);
                    mfB=mf_5vec(dat5,v5B);
                    maxMA=abs(mfA).^2;
                    maxMB=abs(mfB).^2;
                    maxC=C(i,j);
                    maxCA=(norm(mfA*v5A)/normdat5)^2;
                    maxCB=(norm(mfB*v5B)/normdat5)^2;
                end
            end
        end
end

if verb > 0
    figure,image(psi,eta,M,'CDataMapping','scaled'),colorbar
    title('|Matched Filter|^2'),xlabel('\psi'),ylabel('\eta')
    [histM xhistM]=hist(M(:),100);
    figure,hist(M(:),100);
end
 
[x1,y1,z1]=twod_peaks(M,max(M(:))*0.99,1);
M1=max(M(:))-M;
[x2,y2,z2]=twod_peaks(M1,max(M1(:))*0.99,1);

if verb > 0
    fprintf(' Maximum %f at eta = %f and psi = %f \n',z1,eta(x1),psi(y1))
    fprintf(' Minimum %f at eta = %f and psi = %f \n',max(M(:))-z2,eta(x2),psi(y2))
    fprintf('   maxMA,maxMB,maxM %f %f %f \n',maxMA,maxMB,maxM)
    fprintf('Coherence maxCA,maxCB,maxC %f %f %f \n',maxCA,maxCB,maxC)

    figure,image(psi,eta,C,'CDataMapping','scaled'),colorbar
    title('Coherence'),xlabel('\psi'),ylabel('\eta')
end

etamax=eta(x1);
psimax=psi(x1);
a2max=z1;