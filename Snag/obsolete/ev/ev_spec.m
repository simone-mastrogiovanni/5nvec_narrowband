function sp=ev_spec(evch,selev,minfr,maxfr,res)
%EV_SPEC  event spectrum
%
%   ev       event structure
%   selev    event selection array (0 excluded channel)
%   minfr    minimum frequency
%   maxfr    maximum frequency
%   res      resolution

n=evch.n;
t(1:n)=0;
nch=sum(evch.ch.nch);
selev(length(selev)+1:nch)=0;
kk=0;

for k = 1:n
    ch=evch.ev(k).ch;
    if selev(ch) > 0
        kk=kk+1;
        t(kk)=evch.ev(k).t;
    end
end

t=t(1:kk);
if kk < 2
    fprintf(' *** %d events : too few ! \r\n',kk);
end

dfr=2/(res*(t(kk)-t(1)));
fr=minfr;

w=exp(i*mod(t*dfr,1)*2*pi);
wfr=exp(i*mod(t*fr,1)*2*pi);
jj=0;jjj=0;
sp=zeros(1,ceil((maxfr-minfr)/dfr)+2);

while fr < maxfr
    jj=jj+1;
    jjj=jjj+1;
    s=sum(wfr);
    sp(jj)=(s*conj(s))/kk;
    fr=fr+dfr;
    if jjj > 100
        wfr=exp(i*mod(t*fr,1)*2*pi);
        jjj=0;
    else
        wfr=wfr.*w;
    end
end

sp=sp(1:jj);

figure
plot(minfr+(0:jj-1)*dfr,sp), grid on, zoom on
hi=hist(sp,0:0.1:20);