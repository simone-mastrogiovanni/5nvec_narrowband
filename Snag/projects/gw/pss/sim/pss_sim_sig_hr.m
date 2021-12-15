function g=pss_sim_sig_hr(source,antenna,n,nsid,nper)
%PSS_SIM_SIG_HR polarized source simulation signal (for hi res operations)
%
%  source       source structure
%  antenna      detector structure
%  n            number of data
%  nsid         number of points per sidereal day
%  nper         number of points per gw period
%
% for example: g=gw_polariz(sour,ant,16384,1000,10)

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

source1=source;
source1.eps=1;
source1.psi=0;
source2=source;
source2.eps=1;
source2.psi=45;

eps=source.eps;
psi=source.psi*pi/180;
fi=2*psi;
rot=1;
if psi < 0
    rot=-1;
    psi=psi+90;
end

dsid=24/nsid;
sid1=zeros(1,nsid);
sid2=sid1;

for i = 1:nsid
    tsid=i*dsid;
    if antenna.type == 1
        sid1(i)=lin_angr85(antenna,source1,tsid*15);
        sid2(i)=lin_angr85(antenna,source2,tsid*15);
    else
        sid1(i)=lin_radpat_interf(source1,antenna,tsid);
        sid2(i)=lin_radpat_interf(source2,antenna,tsid);
    end
end

% figure
% plot(sid1),hold on
% plot(sid2,'r')
% grid on

ang=0;
dang=2*pi/nper;
r=zeros(1,n);

for i = 1:n
%     xc=cos(ang+fi)*sqrt(1-eps);  % Possible error: check !
%     yc=sin(ang+fi)*sqrt(1-eps);
    xc=cos(ang+fi)*(1-eps)/sqrt(2); 
    yc=sin(ang+fi)*(1-eps)/sqrt(2);
    xl=cos(ang)*eps*cos(2*psi);
    yl=cos(ang)*eps*sin(2*psi);
    ang=mod(ang+dang,2*pi);
    i1=mod(i,nsid)+1;
%     r(i)=sid1(i1)*(xc+xl)+sid2(i1)*(yc+yl); % Possible error: check !
    r(i)=sid1(i1)*(xc+xl)+rot*sid2(i1)*(yc+yl);
end

g=gd(r);
dt=dsid/24;
frsource=1/(nper*dt);
frsid=1;
fr_res=1/(dt*n);
g=edit_gd(g,'dx',dt);
