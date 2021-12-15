function [h_fact eta_bias psi_bias cohe_fact]=ps_bias(v5_0,v5_45,neta,npsi)
% PS_BIAS computes the bias for eta and psi estimation
%
%    bias=ps_bias(v5_0,v5_45,neta,npsi)
%

% Version 2.0 - April 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deta=2/(neta-1);
eta=((0:neta-1)*deta-1);
netanopsi=round(0.2/deta);
dpsi=90/npsi;
psi=(0:npsi-1)*dpsi;

h_fact=zeros(neta,npsi);
eta_bias=h_fact;
psi_bias=h_fact;
cohe_fact=h_fact;

for i = 1:neta
    for j = 1:npsi    
        [Hp Hc]=etapsi2ab(eta(i),psi(j));
        v5sig=(Hp*v5_0+Hc*v5_45);
        [h01 eta1 psi1 cohe1]=simp_estimate_psour(v5sig,v5_0,v5_45);
        h_fact(i,j)=h01;
        eta_bias(i,j)=eta1-eta(i);
        epsi=mod(psi1-psi(j),90);
        if epsi > 45
            epsi=epsi-90;
        end
        psi_bias(i,j)=epsi;
        cohe_fact(i,j)=cohe1;
    end
end

figure,image(psi,eta,h_fact,'CDataMapping','scaled'),colorbar,title('h__fact'),...
    xlabel('\psi'),ylabel('\eta'),grid on
figure,image(psi,eta,eta_bias,'CDataMapping','scaled'),colorbar,title('eta__bias'),...
    xlabel('\psi'),ylabel('\eta'),grid on
psib=psi_bias(netanopsi+1:neta-netanopsi,:);
figure,image(psi,eta(netanopsi+1:neta-netanopsi),psib,'CDataMapping','scaled'),...
    colorbar,title('psi__bias'),xlabel('\psi'),ylabel('\eta'),grid on
figure,image(psi,eta,cohe_fact,'CDataMapping','scaled'),colorbar,title('cohe__fact'),...
    xlabel('\psi'),ylabel('\eta'),grid on
