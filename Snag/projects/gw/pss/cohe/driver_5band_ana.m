% driver_5band_ana

fr0=0.38194046

agwC=compute_5comp(gwC,fr0);

sigs(1,:)=compute_5comp(pL0wien,fr0);
sigs(2,:)=compute_5comp(pL45wien,fr0);
sigs(3,:)=compute_5comp(pCAwien,fr0);
sigs(4,:)=compute_5comp(pCCwien,fr0);

spenhfac=4

[outmf cohe x inif DF]=band_5ana(gwC,fr0,sigs,agwC,[0.255 0.495],spenhfac);