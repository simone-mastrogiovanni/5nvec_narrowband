% compute_mat_matfiltC

fr0=0.38194046;

agwC=compute_5comp(gwC,fr0);

aCA=compute_5comp(pCAwien,fr0);
aCC=compute_5comp(pCCwien,fr0);
aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);

[xL0 cL0 his xh]=matfilt_5comp(agwC,aL0);
[xL45 cL45 his xh]=matfilt_5comp(agwC,aL45);
[xCA cCA his xh]=matfilt_5comp(agwC,aCA);
[xCC cCC his xh]=matfilt_5comp(agwC,aCC);

[L0L0 cL0L0 his xh]=matfilt_5comp(aL0,aL0);
[L0L45 cL0L45 his xh]=matfilt_5comp(aL0,aL45);
[L0CA cL0CA his xh]=matfilt_5comp(aL0,aCA);
[L0CC cL0CC his xh]=matfilt_5comp(aL0,aCC);

[L45L45 cL45L45 his xh]=matfilt_5comp(aL45,aL45);
[L45CA cL45CA his xh]=matfilt_5comp(aL45,aCA);
[L45CC cL45CC his xh]=matfilt_5comp(aL45,aCC);

[CACA cCACA his xh]=matfilt_5comp(aCA,aCA);
[CACC cCACC his xh]=matfilt_5comp(aCA,aCC);

[CCCC cCCCC his xh]=matfilt_5comp(aCC,aCC);

xL0,xL45,xCA,xCC,L0L0,L0L45,L0CA,L0CC,L45L45,L45CA,L45CC,CACA,CACC,CCCC

cL0,cL45,cCA,cCC,cL0L0,cL0L45,cL0CA,cL0CC,cL45L45,cL45CA,cL45CC,cCACA,cCACC,cCCCC