% ex_bsd_dedop_sing
%
% from the bsd primary file

tic

pp0=pulsar_3;
SD=86164.09053083288;

cont=cont_gd(L_C01_20151112_0100_0110_tfstr);
t0=cont.t0;
fr0=cont.inifr;

pp=new_posfr(pp0,t0);
Dfr=pp.f0-pp0.f0;

bsd_corrL=bsd_dopp_sd(L_C01_20151112_0100_0110_tfstr,pp);

sL=gd_pows(bsd_corrL,'resolution',2);

frcent=pp.f0-fr0;
xs=frcent+[-2 -1 0 1 2]/SD;
figure,semilogy(sL),plot_lines(xs,sL,'g')
xlim([frcent-5/SD frcent+5/SD]),grid on

toc
