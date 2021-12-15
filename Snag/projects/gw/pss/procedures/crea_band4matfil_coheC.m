% crea_band4matfil_coheC

fr0=0.38194046

agwC=compute_5comp(gwC,fr0);

aCA=compute_5comp(pCAwien,fr0);
aCC=compute_5comp(pCCwien,fr0);
aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);
sig(1,:)=aL0;
sig(2,:)=aL45;
sig(3,:)=aCA;
sig(4,:)=aCC;

[out cohe inif DF]=band_5matfilt_cohe(gwC,fr0,sig,[0.255 0.495],4);