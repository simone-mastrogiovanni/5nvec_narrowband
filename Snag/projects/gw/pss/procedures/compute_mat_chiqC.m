% compute_mat_chiqC

fr0=0.38194046;

agwC=compute_5comp(gwC,fr0);

aCA=compute_5comp(pCAwien,fr0);
aCC=compute_5comp(pCCwien,fr0);
aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);

[xL0 A mf]=chiq_5comp(agwC,aL0,1);
[xL45 A mf]=chiq_5comp(agwC,aL45,1);
[xCA A mf]=chiq_5comp(agwC,aCA,1);
[xCC A mf]=chiq_5comp(agwC,aCC,1);

[L0L0 A mf]=chiq_5comp(aL0,aL0,1);
[L0L45 A mf]=chiq_5comp(aL0,aL45,1);
[L0CA A mf]=chiq_5comp(aL0,aCA,1);
[L0CC A mf]=chiq_5comp(aL0,aCC,1);

[L45L45 A mf]=chiq_5comp(aL45,aL45,1);
[L45CA A mf]=chiq_5comp(aL45,aCA,1);
[L45CC A mf]=chiq_5comp(aL45,aCC,1);

[CACA A mf]=chiq_5comp(aCA,aCA,1);
[CACC A mf]=chiq_5comp(aCA,aCC,1);

[CCCC A mf]=chiq_5comp(aCC,aCC,1);

xL0,xL45,xCA,xCC,L0L0,L0L45,L0CA,L0CC,L45L45,L45CA,L45CC,CACA,CACC,CCCC