function [pout,dfr]=fu_bsd_patch(pin,cont,patch)
%
%    pout=fu_patches(pin,cont,patch)
%
%   pin    input peak map structure
%   cont   sosa cont
%   patch  patch (patch standard format, only l and b used)

% Snag Version 2.0 - October 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

fr0=cont.sour.f0;
alpha0=cont.sour.a;
delta0=cont.sour.d;
[lam0,bet0]=astro_coord('equ','ecl',alpha0,delta0);
lam=lam0+patch(1);
bet=bet0+patch(2);
[alpha,delta]=astro_coord('ecl','equ',lam,bet);

r=astro2rect([alpha delta],0);

fu=pin.fu;
pout=pin.pm;
ii=find(fu.tfu);
t=fu.tfu(ii);
v=fu.vfu(ii);
vv=fu.vvfu(ii,:);
dfr=fr0*((vv(:,1)-v)*(alpha-alpha0)+(vv(:,3)-v)*(delta-delta0));

if isfield(fu,'wfu')
%     size(fu.vfu)
%     size(fu.wfu)
    w=fu.wfu(ii,:);
else
    w=zeros(length(v),3);
end
vpat=v*0;
for i = 1:length(w)
    vpat(i)=dot(w(i,:),r);
end
dfr1=fr0*(vpat-v);

% figure,plot(dfr)

for i = 1:length(t)
    ii=find(pout(1,:) == t(i));%length(ii)
    pout(2,ii)=pout(2,ii)-dfr(i);
    pout(4,ii)=dfr(i);
    pout(5,ii)=dfr1(i);
end
