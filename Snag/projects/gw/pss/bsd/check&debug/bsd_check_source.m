% bsd_check_source

tic

SD=86164.09053083288;

pp=pulsar_3;  %  not updated sources !
t0_O1=57277;

pp.f0=pp.f0-1;

pp=new_posfr(pp,t0_O1);
fr=pp.f0;
dfr=0.1;

[bsd_outL,BSD_tab_outL,outL]=bsd_lego('I:','ligol','O2',1,[fr-dfr fr+dfr],2);
[bsd_outH,BSD_tab_outH,outH]=bsd_lego('I:','ligoh','O2',1,[fr-dfr fr+dfr],2);

cont=cont_gd(bsd_outL);
t0=cont.t0;
fr0=cont.inifr;

[sbsdL,frL,sig0L]=bsd_softinj(bsd_outL,pp,[0 0 0],1);
[sbsdH,frH,sig0H]=bsd_softinj(bsd_outH,pp,[0 0 0],1);

bsd_corrL=bsd_dopp_sd(sbsdL,pp);
bsd_corrH=bsd_dopp_sd(sbsdH,pp);

sL=gd_pows(bsd_corrL,'resolution',6);
sH=gd_pows(bsd_corrH,'resolution',6);

figure,plot(sL,sH)

frcent=pp.f0-fr0;
xs=frcent+[-2 -1 0 1 2]/SD;
figure,plot(sL,sH),plot_lines(xs,sL,'g')
xlim([frcent-5/SD frcent+5/SD])

toc