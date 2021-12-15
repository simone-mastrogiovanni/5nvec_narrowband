function [period harm perclean win]=gd_period_0(gin,per,nbin,nharm)
% gd_period_0  analysis for the presence of a periodicities with folding
%                SIMPLIFIED
%
%      [period harm perclean win]=gd_period_0(gin,per,nbin,nharm)
%
%   gin      input gd (type 1 or 2)
%   per      period 
%   nbin     number of bins; if array,[nbin xrange icnorm] : xrange =24 for
%               phase in hours, icnorm=1 for normalized values
%   nharm    number of harmonics
%
%   gout     distribution in the period
%   harm     harmonics (from 0 on)
%   perclean fit with nharm harmonics
%   win      folded observation window
% 
%  For type 1 gd, zeroes are null.

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

icnorm=0;
xrange=360;
if length(nbin) > 1
    xrange=nbin(2);
    if length(nbin) > 2
        icnorm=nbin(3);
    end
    nbin=nbin(1);
end
if nbin <= 1
    nbin=100;
end

y=y_gd(gin);
x=x_gd(gin);
ini=ini_gd(gin);
per1=per;

i=find(y);%figure,plot(i),size(i)
y=y(i);
x=x(i);

N=length(y);

period=zeros(1,nbin);
n=period;
i=floor(mod(x/per,1)*nbin)+1;

for j = 1:N
    period(i(j))=period(i(j))+y(j);
    n(i(j))=n(i(j))+abs(sign(y(j))); % 0s are holes
end

win=n;
% peraw=period;
nmax=max(n);
ii=find(n==0);
n(ii)=nmax*1000;

period=period./n;
n=fft(period);
harm=n(1:nharm+1);
n(nharm+2:length(n))=0;
if isreal(y)
    n(length(n):-1:length(n)-nharm+1)=conj(n(2:nharm+1));
end
perclean=ifft(n);

if icnorm == 1
    period=period/mean(period);
    perclean=perclean/mean(perclean);
end

period=gd(period);
period=edit_gd(period,'dx',xrange/nbin);
perclean=gd(perclean);
perclean=edit_gd(perclean,'dx',xrange/nbin);