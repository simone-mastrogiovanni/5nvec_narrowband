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
cont=cont_gd(bsd_i1);
icz1=0;
if isfield(cont,'tfstr')
    if isfield(cont.tfstr,'zeros')
        zeros1=cont.tfstr.zeros;
        [nz1,~]=size(zeros1);
        icz1=1;
    end
end
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
cont2=cont_gd(bsd_i2);
icz2=0;
if isfield(cont2,'tfstr')
    if isfield(cont2.tfstr,'zeros')
        zeros2=cont2.tfstr.zeros;
        [nz2,~]=size(zeros2);
        icz2=1;
    end
end
icz=icz1*icz2;
t02=cont2.t0;

ts2=diff_mjd(t0,t02);
% tstot=ts2+(n2-1)*dt;
ini2=round(ts2/dt)+1;
nn=ini2+n2-1;

yy=zeros(nn,1);
yy(1:n1)=y1;
yy(ini2:nn)=y2;

v_eq2=cont2.v_eq;
p_eq2=cont2.p_eq;
t_dop2=adds2mjd(t02,v_eq2(:,4));
inifr2=cont2.inifr;
bandw2=cont2.bandw;
[ndop2,dum]=size(v_eq2);
if inifr1 ~= inifr2
    sprintf(' *** error ! different inifr %f  %f  (%e)\n',inifr1,inifr2,inifr2-inifr1)
end
if bandw1 ~= bandw2
    sprintf(' *** error ! different bandw %f  %f  (%e) \n',bandw1,bandw2,bandw2-bandw1)
end
v_eq2(:,4)=v_eq2(:,4)+ts2;
p_eq2(:,4)=p_eq2(:,4)+ts2;

v_eq1(ndop1+1:ndop1+ndop2,:)=v_eq2;
p_eq1(ndop1+1:ndop1+ndop2,:)=p_eq2;
cont.v_eq=v_eq1;
cont.p_eq=p_eq1;

cont.tfstr=[];
if icz > 0
    cont.tfstr.zeros=zeros(nz1+nz2,2);
    cont.tfstr.zeros(1:nz1,:)=zeros1;
    cont.tfstr.zeros(nz1+1:nz1+nz2,:)=zeros2+ts2;
end

bsd_o=edit_gd(bsd_i1,'y',yy,'cont',cont);