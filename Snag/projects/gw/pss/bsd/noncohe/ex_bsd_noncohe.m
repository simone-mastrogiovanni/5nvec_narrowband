% ex_bsd_noncohe
%
% non-coherent detection

SD=86164.09053083288;
puls=pulsar_3;
puls=pulsar_8;
puls=GC370L;
% puls=cand1;
fineband=35; % in units of 1/SD

addr='I:';
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
fb2=fineband/2;
freq1=[frdec-fb2/SD,frdec+fb2/SD];
mode=1; puls

[bsd_out,BSD_tab_out,stpar]=bsd_lego(addr,ant,runame,tim,freq,mode);

[bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,puls);

sp=bsd_pows(bsd_corr,4);

FS=1/SD;
Dfr=(-2:2)*FS;
xs=puls.f0+Dfr;

figure,semilogy(sp)
plot_lines(xs,sp)

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

[v,tculm]=bsd_5vec(bsd_ftr,f5v.frs5v(3));