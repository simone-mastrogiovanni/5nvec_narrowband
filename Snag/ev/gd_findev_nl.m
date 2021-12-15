function [ind,len,snr,amp,t,tmax,snr1]=gd_findev_nl(in,tau,maxdin,maxage,deadt,thr,inv)
%GD_FINDEV_NL  finds events in a gd or an array with non-linear procedure
%
%    in      input gd or array
%    tau     AR(1) tau (in samples)
%    maxdin  maximum input variation to evaluate statistics
%    maxage  max age to not update the statistics (same size of tau)
%    deadt   dead time (in samples)
%    thr     threshold
%    inv     > 0 -> starting from the end
%
%    ind     event start (index of the array)
%    len     length (in samples)
%    snr     critical ratio
%    amp     maximum amplitude
%    t       starting time (in case of array, ind-1)
%    tmax    time of the maximum
%    snr1    the total snr array

% Version 2.0 - March 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ind=0;
len=0;
snr=0;
amp=0;
t=0;
tmax=0;

if isnumeric(in)
    dx=1;
    ini=0;
else
    dx=dx_gd(in);
    ini=ini_gd(in);
    in=y_gd(in);
end

n=length(in);
if inv > 0
    inv=1;
    in=in(n:-1:1);
end

w=exp(-1/tau);
amf.nb=0;
amf.b0=1;
amf.na=1;
amf.a(1)=-w;
amf.bilat=0;

snr1=in*0;
%     in1=in;
%     inm1=snr1;
%     inq1=snr1;
inm=in(1);
inq=inm*inm;
norm=1;

age=0;
i=0;

while i < n
    i=i+1;
    in0=in(i);
    if in0/inm < maxdin | norm < 0.5/(1-w)
        norm=1+w*norm;
        inm=in0/norm+w*inm;
        inq=in0*in0/norm+w*inq;
        insd=sqrt(abs(inq-inm*inm));
        age=0;
        in01=in0;
    end
    if age > maxage
        inm=in01;
        i=i-maxage;
        age=0;
        norm=1;
    end
    snr1(i)=(in(i)-inm)./insd;
%     inm1(i)=inm;
%     inq1(i)=inq;
end

if inv > 0
    snr1=snr1(n:-1:1);
end

stat=0;
len=0;
count=0;
nev=0;

for i = 2:n
    if stat == 1
        count=count+1;
        if count > deadt
            stat=0;
            len(nev)=len(nev)-deadt;
        else
            len(nev)=len(nev)+1;
            if amp(nev) < in(i)
                amp(nev)=in(i);
                tmax(nev)=(i-1)*dx+ini;
            end
        end
    end
    if snr1(i) > thr
        if stat == 0
            nev=nev+1;
            ind(nev)=i;
            len(nev)=1;
            t(nev)=(i-1)*dx+ini;
            tmax(nev)=t(nev);
            snr(nev)=snr1(i);
            amp(nev)=in(i);
        end
        stat=1;
        count=0;
    end
end
        
    
