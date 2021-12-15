function gout=bsd_mock_noise(gin,kfact,nonst)
% bsd mock noise
%
%  gin    input bsd (to simulate)
%  kfact  reduction factor (integer)
%  nonst  (if present) non-stationary mask (with holes)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

at=tic;
sp=y_gd(gd_pows(gin,'pieces',kfact));
cont=ccont_gd(gin);
n=length(sp);
[nv0,dum]=size(cont.v_eq);
dt=dx_gd(gin);
nv=ceil(n*dt/(cont.Tfft/2));
nv=min(nv,nv0);
cont.v_eq=cont.v_eq(1:nv,:);
cont.p_eq=cont.p_eq(1:nv,:);
cont.tcreation=datetime();

oper=struct();
oper.op='bsd_mock_noise';
if isfield(cont,'oper')
    oper.oper=cont.oper;
end
oper.kfact=kfact;

cont.oper=oper;

sp=sqrt(sp).*(randn(n,1)+1j*randn(n,1));
sp=ifft(sp);
if exist('nonst','var')
    N=length(nonst);
    ns1=interp1(0:N-1,nonst,(0:n-1)*N/n);
    ii=find(isnan(ns1));
    ns1(ii)=1;nnan=length(ii)
    mu=mean(ns1);
    ns1=ns1/mu; figure,plot(ns1),grid on
    sp=sp.*ns1'; figure,plot(real(sp)),grid on
    oper.nonst=nonst;
end
gout=gd(sp*sqrt(n/(dt*sqrt(3))));
cont.durcreation=toc(at);
cont.type='bsd_mock_noise';
gout=edit_gd(gout,'dx',dt,'cont',cont);