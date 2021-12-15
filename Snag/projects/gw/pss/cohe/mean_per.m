function [yper yper0 yper0_dewin]=mean_per(gin,nharm,nbin,per)
% MEAN_PER  mean in a period
%
%   [ysid ysid0 ysid0_dewin]=mean_per(gin,nharm,per)
%
%   gin     gin.x in s, gin.cont = initial mjd
%   nharm   number of harmonics (def 10)
%   nbin    number of bins (def 240)
%   per     period (in s; def 'sid') 

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('per','var')
    per='sid';
end

if ~exist('nbin','var')
    nbin=240;
end

if ~exist('nharm','var')
    nharm=10;
end

x=x_gd(gin);
x=(x-x(1))/86400+cont_gd(gin);

if ischar(per)
    switch per
        case 'day'
            per=1;
        case 'week'
            per=7;
        case 'sid'
            x=gmst(x);
            per=24;
    end
else
    per=per/86400;
end

yper=zeros(1,nbin);
yper0=yper;

y=abs(y_gd(gin)).^2;
iii=find(y);
x=x(iii);
y=y(iii);
ii=floor(nbin*mod(x,per)/per+1);
iii=find(ii>240);
ii(iii)=240;

for i = 1:nbin
    iii=find(ii==i);
    yper0(i)=sum(y(iii));
    yper(i)=yper0(i)/length(iii);
end

figure,plot(yper),hold on,plot(yper0*mean(yper)/mean(yper0),'r'),grid on