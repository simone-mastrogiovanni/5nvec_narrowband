function [period harm perclean win]=gd_period(gin,per,nbin,nharm,ph)
% GD_PERIOD  analysis for the presence of a periodicities with folding
%
%      [gout harm]=gd_period(gin,per,nbin,nharm)
%
%   gin      input gd (type 1 or 2)
%   per      period (number,if string, time in mjd, except "ssid" and "sday")
%             "day" "sday" "week" "sid" "ssid"
%   nbin     number of bins; if array,[nbin xrange icnorm] : xrange =24 for
%               phase in hours, icnorm=1 for normalized values
%   nharm    number of harmonics
%   ph       phase of the first sample (degrees; 0 if absent; 
%            if sid or ssid, 'gst' uses Greenwich Sidereal Time or an
%            antenna structure -> local sidereal time
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
y=y_gd(gin);
x=x_gd(gin);
ini=ini_gd(gin);
per1=per;
cont=cont_gd(gin);
if isstruct(cont)
    if isfield(cont,'t0')
        format long
        t0=cont.t0
    end
    if exist('ph','var')
        if isstruct(ph)
            long=ph.long;
        end
    end
end
if ~exist('t0','var')
    if ini > 51000 & ini < 60000
        disp('ini is considered mjd !')
        t0=ini;
    else
       disp('ini is considered s since 0 hour !')
        t0=ini/86400; 
    end
end
if exist('ph','var')
    if ischar(ph)
        if strcmp(ph,'gst')
            long=0;
        end
    end
    if isstruct(ph)
        long=ph.long;
    end
else
    ph=0;
end

phsol=(t0-floor(t0))*360;
if ~exist('ph','var')
    ph=phsol;
end
if exist('long','var')
    phsid=gmst(t0)*15+long;
    phasid=agmst(t0)*15+long;
end

i=find(y);%figure,plot(i),size(i)
y=y(i);
x=x(i);

N=length(y);

if ischar(per)
    switch per
        case 'day'
            per=1;
            if ~isnumeric(ph)
                ph=phsol;
            end
        case 'sday'
            per=86400;
            if ~isnumeric(ph)
                ph=phsol;
            end
        case 'week'
            per=7;
%             ph=360*5/7;
        case 'sid'
            per=1/1.002737909350795;
            if ~isnumeric(ph)
                ph=phsid;
            end
        case 'ssid'
            per=86400/1.002737909350795;
            if ~isnumeric(ph)
                ph=phsid;
            end
        case 'asid'
            per=1/(2-1.002737909350795);
            if ~isnumeric(ph)
                ph=phasid;
            end
        case 'assid'
            per=86400/(2-1.002737909350795);
            if ~isnumeric(ph)
                ph=phasid;
            end
    end
end

if isnumeric(ph)
    fprintf('Phase of the first sample: %f \n',ph)
end
x=x-ini+per*ph/360;

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