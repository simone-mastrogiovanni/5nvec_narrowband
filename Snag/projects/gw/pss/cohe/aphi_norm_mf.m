function [M amax bmax]=aphi_norm_mf(dat5,v5A,v5B,na,nphi,verb)
% APHI_NORM_MF  creates a/phi 4-dof 2 different formula normalized mf from 2 base 5-vecs
%
%    [M eta psi M1 histM xhistM]=aphi_norm_mf(dat5,v5A,v5B,na,nphi,verb)
%
%   dat5        data 5-vec
%   v5A,v5B     base 5-vecs
%   na,nphi   number of etas and psis
%   verb        verbosity (def=1)
%
%   M           MF matrix
%   M1          Other formula

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('verb','var')
    verb=1;
end

M=zeros(na,nphi);
M1=M;

da=1/(na-1);
a=0:da:1;
dphi=360/nphi;
phi=(0:nphi-1)*dphi;
phi0=phi*pi/180;
v=zeros(5,nphi);
maxM=0;
maxM1=0;

L0_2=norm(v5A)^2;
L45_2=norm(v5B)^2;
mf0=mf_5vec(dat5,v5A);
mf45=mf_5vec(dat5,v5B);

for i = 1:na
    ai=a(i);
    for j = 1:nphi
        Hp=ai;
        Hc=sqrt(1-ai*ai)*(cos(phi0(j))+1j*sin(phi0(j)));
        A=Hp.*v5A+Hc.*v5B;
        F=conj(A)/norm(A);
        nmf=sum(dat5.*F);
        mf=mf_5vec(dat5,A);
        M(i,j)=abs(nmf).^2;
%         M1(i,j)=abs((Hp*L0_2*mf0+conj(Hc)*L45_2*mf45)/(Hp^2*L0_2+L45_2*abs(Hc)^2))^2;
        if M(i,j) > maxM
            maxM=M(i,j);
            amax=Hp;
            bmax=Hc;
%             maxC=M1(i,j);
%             maxCA=(norm(mfA*v5A)/normdat5)^2;
%             maxCB=(norm(mfB*v5B)/normdat5)^2;
        end
        if M1(i,j) > maxM1
            maxM1=M1(i,j);
        end
    end
end

if verb > 0
    figure,image(phi,a,M,'CDataMapping','scaled'),colorbar
    title('|Normalized Matched Filter|^2'),xlabel('\phi'),ylabel('a')

    [x1,y1,z1]=twod_peaks(M,max(M(:))*0.99,1);
    Mm=max(M(:))-M;
    [x2,y2,z2]=twod_peaks(Mm,max(Mm(:))*0.99,1);

    fprintf(' Maximum %f at a = %f and phi = %f \n',z1,a(x1),phi(y1))
    fprintf(' Minimum %f at a = %f and phi = %f \n',max(M(:))-z2,a(x2),phi(y2))
    [eta psi]=ab2etapsi(amax,bmax);
    fprintf('Check source : eta,psi : %f %f \n',eta,psi);
end