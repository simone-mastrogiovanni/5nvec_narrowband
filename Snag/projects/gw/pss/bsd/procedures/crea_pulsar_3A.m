% crea_pulsar_3A

Df0=-2;

pulsar_3A=pulsar_3;
pulsar_3A.f0=pulsar_3A.f0+Df0;

bsd_out=bsd_lego('I:','ligol','O2',1,pulsar_3A.f0+[-0.5 0.5],1)

bsd_p3A=bsd_softinj_re_mod(bsd_out,pulsar_3A,1);