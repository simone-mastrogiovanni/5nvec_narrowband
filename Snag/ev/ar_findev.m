function [ind,len,snr,amp,t,tmax,zf]=ar_findev(in,tau,deadt,thr,zi)
%AR_FINDEV  finds events in an array
%
%    in      input gd or array
%    tau     AR(1) tau (in samples)
%    deadt   dead time (in samples)
%    thr     threshold
%    zi      status (for continuous operations)
%
%    ind     event start (index of the array)
%    len     length (in samples)
%    snr     critical ratio
%    amp     maximum amplitude
%    t       starting time (in case of array, ind-1)
%    tmax    time of the maximum
%    snr1    the total snr array

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~iscell(zi)
    zi={0 0 0 0 0 0 0 0 0};
end

n=length(in);
maxevn=round(n/3);
len=zeros(1,maxevn);
amp=len;
tmax=len;
t=len;
snr=len;
ind=len;

zim=zi{1};
ziq=zi{2};
stat=zi{3};
count=zi{4};
len(1)=zi{5};
amp(1)=zi{6};
t(1)=zi{7};
tmax(1)=zi{8};
snr(1)=zi{9};

w=exp(-1/tau);
a=[1 -w];
b=1-w;

[inm zfm]=filter(b,a,in,zim);
[inq zfq]=filter(b,a,in.*in,ziq);
    
insd=sqrt(inq-inm.*inm);

snr1=(in-inm)./insd;% plot(snr1),grid on,pause(1)

i=0;

if stat == 0
    nev=0;
else
    nev=1;
end

for i = 1:n
    if stat == 1
        count=count+1;
        if count > deadt
            stat=0;
            len(nev)=len(nev)-deadt;
        else
            len(nev)=len(nev)+1;
            if amp(nev) < in(i)
                amp(nev)=in(i);
                tmax(nev)=(i-1);
            end
        end
    end
    if snr1(i) > thr
        if stat == 0
            nev=nev+1;
            ind(nev)=i;
            len(nev)=1;
            t(nev)=(i-1);
            tmax(nev)=t(nev);
            snr(nev)=snr1(i);
            amp(nev)=in(i);
        end
        stat=1;
        count=0;
    end
end

if nev > 0
    zf={zfm zfq stat count len(nev)  amp(nev) t(nev) tmax(nev) snr(nev)};
else
    zf={zfm zfq stat count 0 0 0 0 0};
end

if stat == 1
    nev=nev-1;
end

len=len(1:nev);
amp=amp(1:nev);
tmax=tmax(1:nev);
t=t(1:nev);
snr=snr(1:nev);
ind=ind(1:nev); 
