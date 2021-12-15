% acc_L_O2_GC036

name='L_O2_GC036';

dirnam='GC';

eval(['direc=' dirnam '();']);

direc.f0=36.0625;
direc.df0=0;
direc.ddf0=0;
direc.fepoch=mjd_now();
direc.pepoch=mjd_now();
direc.v_a=0;
direc.v_d=0;

addr='I:';
ant='ligol';
runame='O2';
tim=[v2mjd([2017,1,4,3,45,0]),v2mjd([2017,8,25,22,37,0])];
freq=[35.5 36.5];
mode=21;

eval(['[' name ', tab_out' name ', out' name ']=bsd_access(addr,ant,runame,tim,freq,mode);'])

eval(['cont' name(1) '=cont_gd(' name ')'])

eval(['n' name(1) '=n_gd(' name ')'])

eval(['dt' name(1) '=dx_gd(' name ')'])

eval(['timfin' name(1) '=dt' name(1) '*n' name(1) '/86400+tim(1)'])

eval(['tfin=mjd2s(timfin' name(1) ')'])

% L_O2_sn1987a_corr=bsd_dopp_sd(L_O2_sn1987a,sn1987a)
eval([name '_corr=bsd_dopp_sd(' name ',direc);'])