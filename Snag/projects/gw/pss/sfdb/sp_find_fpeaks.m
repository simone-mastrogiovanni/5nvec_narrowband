function [ind,fr,snr1,amp,peaks,snr]=sp_find_fpeaks(in,tau,thr,inv)
%SP_FIND_FPEAKS  finds events in a gd or an array with non-linear procedure
%
%    in      input gd or array
%    tau     AR(1) tau (in samples)
%    thr     threshold
%    inv     1 -> starting from the end, 2 -> min of both
%
%    ind     index of the peak (of the snr array)
%    fr      peak frequencies
%    snr1    peak snr
%    amp     peak amplitudes
%    peaks   sparse array
%    snr     the total snr array

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
if inv == 1
    in=in(n:-1:1);
end

w=exp(-1/tau);
amf.nb=0;
amf.b0=1-w;
amf.na=1;
amf.a(1)=-w;
amf.bilat=0;

inm=in(1);
inq=inm*inm;

age=0;
i=0;

if inv < 2
    inm=am_filter(in,amf,inv);
else
    inm=am_filter(in,amf,0);
    inm1=am_filter(in,amf,1);
    
    inm=min(inm,inm1);
end
    
snr=in./inm;

if inv == 1
    snr=snr(n:-1:1);
end

y1=rota(snr,1);
y2=rota(snr,-1);
y1=ceil(sign(snr-y1)/2);
y2=ceil(sign(snr-y2)/2);
y1=y1.*y2;
y=snr.*y1;
y2=ceil(sign(snr-thr)/2);
y1=snr.*y2;
npeak=sum(y2);
[ind,j1,snr1]=find(y1);
amp=in(ind);

fr=(ind-1)*dx;

peaks=sparse(ind,j1,amp);