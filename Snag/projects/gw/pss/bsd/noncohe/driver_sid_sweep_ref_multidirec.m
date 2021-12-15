% driver_sid_sweep_ref_multidirec

pp=new_posfr(pulsar_3,57859);
ppa=pp;
ppb=pp;

ppa.a=pp.a+5;
ppb.d=pp.d+5;

direc{1}=pp;
direc{2}=ppa;
direc{3}=ppb;

 [sidsrefdir,outparsdir]=sid_sweep_ref_multidirec('I:','ligol','O2',pp.f0,direc,[10 5],pp)