% ex_bsd_zoomcand
%
% 

SD=86164.09053083288;
puls=pulsar_3;
% puls=pulsar_0;

addr='H:';
addr='C:\Users\SergiF\Documents\_MATLAB\Ornella'
ant='ligol';
runame='O2';
tim=1;

frdum=puls.f0;
freqdum=[frdum-0.05,frdum+0.05];

BSD_tab_out=bsd_tabout(addr,ant,runame,tim,freqdum);
ntab=length(BSD_tab_out.t_ini);
T00=(BSD_tab_out.t_ini(1)+BSD_tab_out.t_fin(ntab))/2;
T0=BSD_tab_out.t_ini(1);
puls=new_posfr(puls,T0);

frdec=puls.f0;
freq=[frdec-0.05,frdec+0.05];
freq1=[frdec-5.1/SD,frdec+5.1/SD];
mode=1; puls

[bsd_out,BSD_tab_out,stpar]=bsd_lego(addr,ant,runame,tim,freq,mode);

[bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,puls);

sp=bsd_pows(bsd_corr,4);

FS=1/SD;
Dfr=(-2:2)*FS;
xs=puls.f0+Dfr;

figure,semilogy(sp)
plot_lines(xs,sp)

[v,tculm]=bsd_5vec(bsd_corr,xs(3));

hol=bsd_hole_window(bsd_corr,1);

enl=10;
[bsd_ftr,oth]=bsd_ftrim(bsd_corr,freq1,enl)
f5v=find_5vec(oth.sp)
plot_lines(xs,oth.sp)
plot_lines(f5v.frs5v,oth.sp,'m')
fprintf('Theoretical frequency %.7f Hz  found %.7f Hz  diff %d \n',xs(3),f5v.frs5v(3),f5v.frs5v(3)-xs(3))

figure,plot_lines(xs,f5v.fil)
plot(f5v.fr,f5v.fil),grid on

sid=bsd_sid(bsd_ftr,puls,100)

sidpat_base=ana_sidpat_base(ant,puls);
asp=ana_sidpat(sid.pow,sidpat_base)
[v,tculm]=bsd_5vec(bsd_ftr,f5v.frs5v(3));