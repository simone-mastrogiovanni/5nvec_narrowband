% ex_bsd_softinj

tic

SD=86164.09053083288;

dfr=0.1;

modif.typ='source';
pp=pulsar_3;
pp.f0=pp.f0-1;
modif.sour=pp;
modif.phs=[0 0 0];
modif.A=1;

% modif=[];

modifpost.typ='source';
modifpost.sour=pp;
modifpost.phs=[0 0 0];
modifpost.A=1;

modifpost=[];

fr=pp.f0;

[bsd_sinj_L,BSD_tab_outL,outL]=bsd_access('I:','ligol','O1',[57270 57570],[fr-dfr fr+dfr],2,modif,modifpost);

bsd_corrsinj_L=bsd_dopp_sd(bsd_sinj_L,pp);

cont=cont_gd(bsd_sinj_L);
t0=cont.t0;
fr0=cont.inifr;

sL=gd_pows(bsd_corrsinj_L,'resolution',6);

figure,plot(sL)

frcent=pp.f0-fr0;
xs=frcent+[-2 -1 0 1 2]/SD;
figure,plot(sL),plot_lines(xs,sL,'g')
xlim([frcent-5/SD frcent+5/SD])

toc