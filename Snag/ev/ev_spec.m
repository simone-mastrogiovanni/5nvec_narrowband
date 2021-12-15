function sp=ev_spec(evch,selev,wind,minfr,maxfr,res,amp,icplot)
%EV_SPEC  event spectrum (also with amplitude)
%
%   evch      event/channel structure or just a double array with event times
%   selev     event selection array (0 excluded channel)
%   wind(:,2) observation window; if 0, from the first to the last event
%   minfr     minimum frequency
%   maxfr     maximum frequency
%   res       resolution
%   amp       amplitude (with the same length of the events)
%   icplot    1 yes (default), 0 no
%
% To take into account the amplitude, see peak_spec

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('icplot','var')
    icplot=1;
end
if isstruct(evch)
	n=evch.n;
	t(1:n)=0;
	nch=sum(evch.ch.nch);
	selev(length(selev)+1:nch)=0;
	kk=0;
	
	ewyes=0;
	if isfield(evch,'ew')
        ewyes=1;
	else
        evch.ew=ev2ew(evch.ev);
	end
	
	for k = 1:n
        ch=evch.ew.ch(k);
        if selev(ch) > 0
            kk=kk+1;
            t(kk)=evch.ew.t(k);
        end
	end
	
	t=t(1:kk);
else
    t=evch(:)';
    kk=length(t)
end

if ~exist('amp','var') || length(amp) == 1
    amp=ones(1,kk);
elseif length(amp) ~= kk
    fprintf('*** %d events, %d amplitudes \n',kk,length(amp));
    return
end
% amp=amp(:)'/mean(abs(amp));
amp=amp(:)';

if length(wind) > 1
    t=wind_sel(t,wind);
    kk=length(t);
else
    wind(1,1)=min(t);
    wind(1,2)=max(t);
end

if kk < 2
    fprintf(' *** %d events : too few ! \r\n',kk);
end

dfr=1/(res*(max(t)-min(t)));
fr=minfr;

w=exp(i*mod(t*dfr,1)*2*pi);
wfr=exp(i*mod(t*fr,1)*2*pi); wind

winw1=exp(i*mod(wind(:,1)*dfr,1)*2*pi);
winw2=exp(i*mod(wind(:,2)*dfr,1)*2*pi);
winwfr1=exp(i*mod(wind(:,1)*fr,1)*2*pi);
winwfr2=exp(i*mod(wind(:,2)*fr,1)*2*pi);

jj=0;jjj=0;
sp=zeros(1,ceil((maxfr-minfr)/dfr)+2);
winsp=sp;
toss=sum(wind(:,2)-wind(:,1));

while fr < maxfr
    jj=jj+1;
    jjj=jjj+1;
    if fr > 0
        omj=-2*pi*i*fr;
        wins=sum((winwfr1-winwfr2)/omj);
    else
        wins=toss;
    end
    wins=wins*kk/toss;
    %winsp(jj)=(wins*conj(wins));
    s=sum(wfr.*amp)-wins;
    sp(jj)=(s*conj(s))/kk;
    fr=fr+dfr;
    if jjj > 100
        wfr=exp(i*mod(t*fr,1)*2*pi);
        jjj=0;
    else
        wfr=wfr.*w;
        winwfr1=winwfr1.*winw1;
        winwfr2=winwfr2.*winw2;
    end
end

sp=sp(1:jj);
%s=s(1:jj);wins=wins(1:jj);figure,plot(s),figure,plot(wins),s(1:10),wins(1:10)
%winsp=winsp(1:jj);figure,plot(minfr+(0:jj-1)*dfr,winsp)
m=mean(sp),sd=std(sp)

if icplot == 1
    x=(0:0.1:max(sp));
    hi=histc(sp,x);
    figure
    stairs(x,log10(onlypos(hi)));zoom on, grid on

    figure
    plot(minfr+(0:jj-1)*dfr,sp), grid on, zoom on
end

sp=gd(sp);
sp=edit_gd(sp,'ini',minfr,'dx',dfr);
