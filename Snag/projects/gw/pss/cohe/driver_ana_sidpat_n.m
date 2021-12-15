% driver_ana_sidpat_n

pp=new_posfr(pulsar_3,57859)
pp=new_posfr(crab,57859)
pp.eta,pp.psi

sidpat_baseL=ana_sidpat_base(ligol,pp);
sidpat_baseH=ana_sidpat_base(ligoh,pp);
sidpat_baseV=ana_sidpat_base(virgo,pp);
[sidpatL,ftspL,vL]=pss_sidpat(pp,ligol,240,1);
[sidpatH,ftspH,vH]=pss_sidpat(pp,ligoh,240,1);
[sidpatV,ftspV,vV]=pss_sidpat(pp,virgo,240,1);
anaL=ana_sidpat(y_gd(sidpatL),sidpat_baseL);
anaH=ana_sidpat(y_gd(sidpatH),sidpat_baseH);
anaV=ana_sidpat(y_gd(sidpatV),sidpat_baseV);
spb_fit=anaL.spb_fit+anaH.spb_fit+anaV.spb_fit;
ants{1}=ligol;
ants{2}=ligoh;
ants{3}=virgo;
sidpats{1}=sidpatL;
sidpats{2}=sidpatH;
sidpats{3}=sidpatV;
out=ana_sidpat_n(ants,sidpats,pp);

eta1=out.ana{1}.eta0(1);
psi1=out.ana{1}.psi0(1);

eta2=out.ana{2}.eta0(1);
psi2=out.ana{2}.psi0(1);

eta3=out.ana{3}.eta0(1);
psi3=out.ana{3}.psi0(1);

fprintf('%s 0 -> %.2f %.0f  1 -> %.2f %.0f  2 -> %.2f %.0f  3 -> %.2f %.0f  \n',pp.name,pp.eta,mod(pp.psi,90),eta1,psi1,eta2,psi2,eta3,psi3)