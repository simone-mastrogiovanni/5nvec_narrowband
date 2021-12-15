function [fit comp]=fitper_sf(gin,nh)
% fitper_sf  fit for periodic functions with holes (sf)
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
norm=2/n;
my1=mean(y1);

for i = 1:nh
    om=2*pi*i/per;
    comp(i+1)=norm*sum((y1-my1).*exp(-1j*om*t1));
    fit1=fit1+comp(i+1).*exp(1j*om*t1);
end

const=mean(y1)-mean(fit1);
comp(1)=const;
fit=zeros(n,1)+const;

for i = 1:nh
    om=2*pi*i/per;
    tau=atan(sum(sin(2*om*t1))/sum(cos(2*om*t1)))/(2*om);
    fit=fit+comp(i+1).*exp(1j*om*t);
end

fit=real(fit);

if length(ii) < n/4
    fit=y*0+1; % ATTENTION !!
end

if icgd == 1
    fit=edit_gd(fit,'ini',ini,'dx',dt);
end

% figure,plot(t1,y1),hold on,plot(t,fit,'r--')