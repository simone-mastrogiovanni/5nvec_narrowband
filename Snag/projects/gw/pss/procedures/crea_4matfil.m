% crea_4matfil

aCA=compute_5comp(pCAwien,0.38198710)
aCC=compute_5comp(pCCwien,0.38198710);
aL0=compute_5comp(pL0wien,0.38198710);
aL45=compute_5comp(pL45wien,0.38198710);
mf(1,:)=conj(aL0)/sum(abs(aL0).^2);
mf(2,:)=conj(aL45)/sum(abs(aL45).^2);
mf(3,:)=conj(aCA)/sum(abs(aCA).^2);
mf(4,:)=conj(aCC)/sum(abs(aCC).^2);

[out inif DF]=check_5matfilt(gwB,0.38198710,mf,[0.255 0.495]);