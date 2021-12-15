function [fit comp]=fitper_losc(gin,nh)
% fitper_losc  fit for periodic functions with holes (lomb-scargle)
%
%  [fit comp]=fitper_losc(gin,nh)
%
%    gin   input type-1 gd or array (zeroes are holes)
%    nh    number of harmonics (def 4)

% Version 2.0 - December 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isnumeric(gin)
    n=length(gin);
    gin=gd(gin);
    icgd=0;
else
    icgd=1;
end

if ~exist('nh','var')
    nh=4;
end

t=x_gd(gin);
y=y_gd(gin);
n=n_gd(gin);
ini=ini_gd(gin);
dt=dx_gd(gin);
per=n*dt;

ii=find(y ~= 0);
y1=y(ii);
t1=t(ii);
fit1=0;
norm=sqrt(2/n);
my1=mean(y1);

for i = 1:nh
    om=2*pi*i/per;
    tau=atan(sum(sin(2*om*t1))/sum(cos(2*om*t1)))/(2*om);
    re(i)=norm*sum((y1-my1).*cos(om*(t1-tau)))/sqrt(sum(cos(om*(t1-tau)).^2));
    im(i)=norm*sum((y1-my1).*sin(om*(t1-tau)))/sqrt(sum(sin(om*(t1-tau)).^2));
    fit1=fit1+cos(om*(t1-tau))*re(i)+sin(om*(t1-tau))*im(i);
    comp(i+1)=re(i)+1j*im(i);
end

const=mean(y1)-mean(fit1);
comp(1)=const;
fit=zeros(n,1)+const;

for i = 1:nh
    om=2*pi*i/per;
    tau=atan(sum(sin(2*om*t1))/sum(cos(2*om*t1)))/(2*om);
    fit=fit+cos(om*(t-tau))*re(i)+sin(om*(t-tau))*im(i);
end

if icgd == 1
    fit=edit_gd(fit,'ini',ini,'dx',dt);
end
