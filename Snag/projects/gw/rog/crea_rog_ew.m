%CREA_ROG_EW  creation of a ew file for rog antennas

chstr.na=2;
chstr.nch(1)=1;
chstr.an(1)=1;
chstr.ty(1)={'clean (38)'};
chstr.st(1)=0.0032;
chstr.cf(1)=0;
chstr.bw(1)=0;
chstr.lcn(1)=0;
chstr.nch(1)=1;
chstr.an(2)=2;
chstr.ty(2)={'clean (38)'};
chstr.st(2)=0.0032;
chstr.cf(2)=0;
chstr.bw(2)=0;
chstr.lcn(2)=0;

ew=evrog2ew('D:\Data\Rog\Eventi\nautilus2003.eve');
ew1=evrog2ew('D:\Data\Rog\Eventi\explorer2003.eve');

ew.ch(1:ew.nev)=1;
ew1.ch(1:ew1.nev)=2;

ew.l=ew.l*chstr.st(1);
ew1.l=ew1.l*chstr.st(2);

nev1=ew.nev;

nev=nev1+ew1.nev;
ew.nev=nev;
ew.t(nev1+1:nev)=ew1.t;
ew.tm(nev1+1:nev)=ew1.tm;
ew.ch(nev1+1:nev)=ew1.ch;
ew.a(nev1+1:nev)=ew1.a;
ew.cr(nev1+1:nev)=ew1.cr;
ew.a2(nev1+1:nev)=ew1.a2;
ew.l(nev1+1:nev)=ew1.l;
ew.fl(nev1+1:nev)=ew1.fl;
ew.ci(nev1+1:nev)=ew1.ci;

clear ew1

ew=sort_ev(ew)
evch=crea_evch(chstr,ew)

clear ew
