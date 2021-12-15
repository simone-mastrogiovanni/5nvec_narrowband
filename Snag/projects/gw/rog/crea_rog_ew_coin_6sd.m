%CREA_ROG_EW_COIN_1_5sd  creation of a ew file for rog antennas

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

ew=evrogcoin2ew('D:\Data\Rog\Eventi\shiftfile01_6sigma.info');
ew1=evrogcoin2ew('D:\Data\Rog\Eventi\shiftfile03_6sigma.info');

evch2001=crea_evch(chstr,ew)
evch2003=crea_evch(chstr,ew1)

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
evch_tot=crea_evch(chstr,ew)

clear ew

 evch2001fl=ev_sel(evch2001,0,0,0,0,[0.5 1.5])
 evch2003fl=ev_sel(evch2003,0,0,0,0,[0.5 1.5])
 evch_totfl=ev_sel(evch_tot,0,0,0,0,[0.5 1.5])
 
 [dcp,t]=ev_coin(evch_totfl,[1 2],0,1,100,1);

