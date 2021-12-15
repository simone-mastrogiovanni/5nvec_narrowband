function [ind,len,snr,amp,t,tmax,snr1]=gd_findev(in,tau,deadt,thr,inv)
%GD_FINDEV  finds events in a gd or an array
%
%    in      input gd or array
%    tau     AR(1) tau (in samples)
%    deadt   dead time (in samples)
%    thr     threshold
%    inv     1 -> starting from the end, 2 -> min of both
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

if isnumeric(in)
    dx=1;
    ini=0;
else
    dx=dx_gd(in);
    ini=ini_gd(in);
    in=y_gd(in);
end

n=length(in);

w=exp(-1/tau);
amf.nb=0;
amf.b0=1;
amf.na=1;
amf.a(1)=-w;
amf.bilat=0;
norm=1-w;

inm=in*0;
inq=inm;
insd=inm;
if inv < 2
    inm=am_filter(in,amf,inv)*norm;
    inq=am_filter(in.*in,amf,inv)*norm;
else
    inm=am_filter(in,amf,0)*norm;
    inq=am_filter(in.*in,amf,0)*norm;
    inm1=am_filter(in,amf,1)*norm;
    inq1=am_filter(in.*in,amf,1)*norm;
    
    inm=min(inm,inm1);
    inq=min(inq,inq1);
end
    
insd=sqrt(inq-inm.*inm);

snr1=(in-inm)./insd;

stat=0;
i=0;
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
        
    
