function g=sds_lockin(file,t,fr,band,rdt,filout,lfftout)
% SDS_LOCKIN  applyes a lock-in to an sds stream; creates a gd and a new unique sds
%        good for very narrow bands (if dtin=1/4096, typically rdt=4096, band=0.5)
%    LIMITATION: the sds are supposed to contain a single channel
%
%     g=sds_lockin(file,t,fr,band,rdt,filout)
%
%   file    the first file (or 0 -> interactive choice)
%   t       [tinit tfin] or 0 -> all
%   fr      frequency 
%   band    band
%   rdt     reduction of sampling time(integer)
%   filout  output sds file

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isnumeric(file)
    file=selfile(' ');
end

if length(t) < 2
    t=[0 1.e6];
end

if ~exist('filout','var') || filout == 0
    filout='out.sds';
end

if ~exist('lfftout','var')
    lfftout=128;
end

iw1=2;

rdt=round(rdt);

sds_=sds_open(file);
str=sprintf(' *** open file %s',sds_.filspost);
disp(str);

t0=sds_.t0;
dtin=sds_.dt;
dt=dtin*rdt;
len=sds_.len;
fint=t0+len*dtin/86400;
n=rdt*lfftout;
n2=n/2;
n4=n/4;
n3=n4*3;
tin=t0;
t1=t0;
g=[];
dfr=1/(n*dtin);
ifr=round(fr/dfr)+1;
fr0=(ifr-1)*dfr;
bandmax=1/dt;
if band > 1.02*bandmax
    band=bandmax/1.021;
    disp('band reduction')
end
iband20=round(band/(2*dfr));
iband2=iband20+iw1
ifr1=ifr-iband2;
ifr2=ifr+iband2;
m4=lfftout/4;
yf=zeros(1,lfftout);

while fint < t(1)
    sds_=sds_open([sds_.pnam sds_.filspost]);
    t0=sds_.t0;
    len=sds_.len;
    fint=t0+len*dtin/86400;
    str=sprintf(' *** open file %s',sds_.filspost);
    disp(str);
end

x=zeros(n,1);
[x(n3+1:n) tim0 cont sds_]=read_sds_vec(sds_,n4,t1);
nn=n4;
npiec=1;

while 1
    x(1:n2)=x(n2+1:n);
    t2=t1+nn*dtin/86400;
    [x(n2+1:n) t1 cont sds_]=read_sds_vec(sds_,n2,t2); 
    npiec=npiec+1;
    if sds_.eof >= 2
        break
    end
    if t1 > t(2)
        break
    end
    if t1 < t(1)
        continue
    end
    nn=n2;
    if cont == 1
        hole=(t1-t2)*86400/dt;
        ihole=ceil(hole+1/(10*rdt));
        g=[g zeros(1,ihole)];
        idel=round((ihole-hole)*rdt);
        fprintf('Hole of %f s at piece %d on %s; %d input samples deleted\n',hole*dt,npiec,mjd2s(t1),idel)
%         x(n4+1:n4+n2-idel)=x(n4+1+idel:n4+n2);
        x(n4+1:n4+n2-idel)=x(n2+1+idel:n);
        nrest=n2-n4+idel;
        t2=t1+nn*dtin/86400;
        [x(n4+n2-idel+1:n) t1 cont sds_]=read_sds_vec(sds_,nrest,t2);
        nn=nrest;
    end
    xf=fft(x);%iband2,ifr2-ifr+1
    yf(1:iband2+1)=xf(ifr:ifr2);%lfftout,ifr,iband2,ifr2
    yf(lfftout:-1:lfftout-iband2)=xf(ifr-1:-1:ifr-iband2-1);
    yf(iband2)=yf(iband2)*0.25;
    yf(iband2-1)=yf(iband2-1)*0.5;
    yf(lfftout-iband2+1)=yf(lfftout-iband2+1)*0.25;
    yf(lfftout-iband2+2)=yf(lfftout-iband2+2)*0.5;
    yf=ifft(yf);
    g=[g yf(m4+1:3*m4)];
end

g=gd(g);
g=edit_gd(g,'dt',dt,'ini',(tim0-floor(tim0))*86400,'cont',fr0);