% ex_bsd_dedop
%
% after ex_bsd_sband

tic

pp0=pulsar_3;
SD=86164.09053083288;

cont=cont_gd(bsd_outL);
t0=cont.t0;
fr0=cont.inifr;
% x=x_gd(bsd_outL);

pp=new_posfr(pp0,t0);
Dfr=pp.f0-pp0.f0;

bsd_corrL=bsd_dopp_sd(bsd_outL,pp);
bsd_corrH=bsd_dopp_sd(bsd_outH,pp);

sL=bsd_pows(bsd_corrL,6);
sH=bsd_pows(bsd_corrH,6);

figure,plot(sL,sH)

frcent=pp.f0;
xs=frcent+[-2 -1 0 1 2]/SD;
figure,plot(sL,sH),plot_lines(xs,sL,'g')
xlim([frcent-5/SD frcent+5/SD])

toc