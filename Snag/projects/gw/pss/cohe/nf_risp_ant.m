function [S modS]=nf_risp_ant(Sp,Sx,eta,psi)
% NF_RISP_ANT  computes the antenna 5-vector response from the 5-vectors
%
%      S=nf_risp_ant(Sp,Sx,eta,psi)
%
%     Sp,Sx     5-vectors response to plus and x radiation
%     eta,psi   parameters
%
%     S         output 5 vector
%     modS      |S|

% Version 2.0 - July 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

eta=eta(:);
neta=length(eta);
psi=psi(:);
npsi=length(psi);
S=zeros(neta,npsi,5);
modS=zeros(neta,npsi);

for i = 1:neta
    ap=sqrt(1./(1+eta(i).^2));
    ax=sign(eta(i)).*sqrt(eta(i).^2./(1+eta(i).^2));
    for j = 1:npsi
        psi1=psi(j)*pi/180;
        hp=ap.*cos(2*psi1)-1j*ax.*sin(2*psi1);
        hx=ap.*sin(2*psi1)+1j*ax.*cos(2*psi1);
        h=hp*Sp+hx*Sx;
        S(i,j,:)=h;
        modS(i,j)=sqrt(sum(abs(S(i,j,:)).^2));
    end
end