% acc_H_O2_sn1987a

name='H_O2_sn1987a';

addr='I:';
ant='ligoh';
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