% ex_bsd_modif

tic

dfr=0.1;

modif.typ='sinsig';
modif.t00=57270;
modif.fr=108.8;
modif.ph=0;
modif.amp=1;

% modif=[];

modifpost.typ='sinsig';
modifpost.t00=57270;
modifpost.fr=108.8;
modifpost.ph=0;
modifpost.amp=1;

modifpost=[];

fr=modif.fr;

[bsd_outL,BSD_tab_outL,outL]=bsd_access('I:','ligol','O1',[57270 57570],[fr-dfr fr+dfr],2,modif,modifpost);

toc