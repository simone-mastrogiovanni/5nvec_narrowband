function [h_fact eta_corr psi_corr cohe_fact]=ps_bias_correct(eta_err,psi_err,v5_0,v5_45,neta,npsi)
% PS_BIAS computes the bias correction for eta and psi estimation
%
%    [h_fact eta_corr psi_corr cohe_fact]=ps_bias_correct(eta_err,psi_err,v5_0,v5_45,neta,npsi)
%

% Version 2.0 - April 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

eta_corr=0;psi_corr=0;
deta=2/(neta-1);
etain=((0:neta-1)*deta-1);
netanopsi=round(0.2/deta);
dpsi=90/npsi;
psiin=(0:npsi-1)*dpsi;

h_fact=zeros(neta,npsi);
eta_new=h_fact;
psi_new=h_fact;
psie=h_fact;
eta_bias=h_fact;
psi_bias=h_fact;
cohe_fact=h_fact;

for i = 1:neta
    for j = 1:npsi    
        [Hp Hc]=etapsi2ab(etain(i),psiin(j));
        v5sig=(Hp*v5_0+Hc*v5_45);
        [h01 eta1 psi1 cohe1]=simp_estimate_psour(v5sig,v5_0,v5_45);
        h_fact(i,j)=h01;
        eta_new(i,j)=eta1;
        if psi1 < 0
            psi1=psi1+90;
        end
        psie(i,j)=psi1 - psi_err;
        if psie(i,j) > 45
            psie(i,j)=psie(i,j)-90;
        end
        if psie(i,j) > 45
            psie(i,j)=psie(i,j)-90;
        end
        psi_new(i,j)=psi1;
        cohe_fact(i,j)=cohe1;
    end
end

figure,image(psiin,etain,eta_new,'CDataMapping','scaled'),colorbar,title('eta__new'),grid on
figure,image(psiin,etain,psi_new,'CDataMapping','scaled'),colorbar,title('psi__new'),grid on

err_eta=0.1;
err_psi=10;
const=0.3;
err_eta=err_eta*const;
err_psi=err_psi*const;

[i1 j1 eta1]=find(abs((eta_new-eta_err)) < err_eta);
[i2 j2 psi1]=find(abs(psie) < err_psi);

E=sparse(i1,j1,eta1,neta,npsi);figure,spy(E)
P=sparse(i2,j2,psi1,neta,npsi);figure,spy(P)

[i3 j3 ep]=find(E.*P);

EP=sparse(i3,j3,ep,neta,npsi);figure,spy(EP)

meta=mean(mean(abs(eta_new(i3,j3)-eta_err)))
mpsi=mean(mean(abs(psi_new(i3,j3)-psi_err)))

n=length(i3);
eta1=zeros(1,n);
psi1=eta1;

for i = 1:n
    eta1(i)=eta_new(i3(i),j3(i));
    psi1(i)=psi_new(i3(i),j3(i));
end

psigain=1;
dist=sqrt((eta1-eta_err).^2/meta+psigain*(psi1-psi_err).^2/mpsi);
[dmin imin]=min(dist); dmin

iout=i3(imin);
jout=j3(imin);
eta_corr=(iout-1)*deta-1;
psi_corr=(jout-1)*dpsi;
h_fact=h_fact(iout,jout);
cohe_fact=cohe_fact(iout,jout);