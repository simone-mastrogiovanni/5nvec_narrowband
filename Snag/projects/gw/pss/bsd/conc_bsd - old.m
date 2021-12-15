function [bsd_o,ini2]=conc_bsd(bsd_i1,bsd_i2)
% concatenates two bsd that should be compatible (same band, same sampling time)
%
%    bsd_i1   first input bsd
%    bsd_i2   first input bsd

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(bsd_i1);
n1=n_gd(bsd_i1);
y1=y_gd(bsd_i1);
cont=ccont_gd(bsd_i1);
t0=cont.t0;
v_eq1=cont.v_eq;
p_eq1=cont.p_eq;
t_dop1=adds2mjd(t0,v_eq1(:,4));
[ndop1,dum]=size(v_eq1);
inifr1=cont.inifr;
bandw1=cont.bandw;

dt2=dx_gd(bsd_i2);
if dt ~= dt2
    error(' *** error ! different sampling times %f  %f \n',dt,dt2)
end
n2=n_gd(bsd_i2);
y2=y_gd(bsd_i2);
cont2=ccont_gd(bsd_i2);
t02=cont2.t0;
ts2=diff_mjd(t0,t02);
ts=ts2+(n2-1)*dt;
v_eq2=cont2.v_eq;
p_eq2=cont2.p_eq;
t_dop2=adds2mjd(t02,v_eq2(:,4));
inifr2=cont2.inifr;
bandw2=cont2.bandw;
[ndop2,dum]=size(v_eq2);
if inifr1 ~= inifr2
    sprintf(' *** error ! different inifr %f  %f \n',inifr1,inifr2)
end
if bandw1 ~= bandw2
    sprintf(' *** error ! different bandw %f  %f \n',bandw1,bandw2)
end
s12=diff_mjd(t0,t02);
v_eq2(:,4)=v_eq2(:,4)+s12;
p_eq2(:,4)=p_eq2(:,4)+s12;

v_eq1(ndop1+1:ndop1+ndop2,:)=v_eq2;
p_eq1(ndop1+1:ndop1+ndop2,:)=p_eq2;
cont.v_eq=v_eq1;
cont.p_eq=p_eq1;

nn=round(ts/dt);
yy=zeros(nn,1);
ini2=nn-n2+1;
yy(ini2:nn)=y2;
yy(1:n1)=y1;

cont.tfstr=[];

bsd_o=edit_gd(bsd_i1,'y',yy,'cont',cont);