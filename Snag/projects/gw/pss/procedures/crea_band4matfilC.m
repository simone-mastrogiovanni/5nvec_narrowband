% crea_band4matfilC

fr0=0.38194046

agwC=compute_5comp(gwC,fr0);

aCA=compute_5comp(pCAwien,fr0);
aCC=compute_5comp(pCCwien,fr0);
aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);
mf(1,:)=conj(aL0)/sum(abs(aL0).^2);
mf(2,:)=conj(aL45)/sum(abs(aL45).^2);
mf(3,:)=conj(aCA)/sum(abs(aCA).^2);
mf(4,:)=conj(aCC)/sum(abs(aCC).^2);

[out inif DF]=band_5matfilt(gwC,fr0,mf,[0.255 0.495],8);