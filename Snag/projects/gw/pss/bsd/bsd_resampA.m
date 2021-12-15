function out=bsd_resamp(in,direc,res)
% resampling procedure for doppler
%   spin-down correction should be done by sub-heterodyne after this
%
%    out=bsd_resamp(in,direc,res)
%
%   in     input bsd
%   direc  direction structure
%   res    resolution gain (integer; def 200);
%
%  buf is delayed of 

% Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.Piccinni, S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

tic

toff=-1;
% AU=149597870700;
% c=	299792458;

if ~exist('res','var')
    res=200;
end

cont=ccont_gd(in);
t0=cont.t0;
p_eq=cont.p_eq;
v_eq=cont.v_eq;
inifr=cont.inifr;
bandw=cont.bandw;
if (inifr+bandw)/bandw > res/2
    fprint('res = %f too low, at least %f',res,round(2*(inifr+band)/band))
    return
end
dt=dx_gd(in);
ddt=dt/res;
n=n_gd(in);
y=y_gd(in);
yr=y*0;

[npv,~]=size(p_eq);

DT=p_eq(2,4)-p_eq(1,4);
nfft2=round(DT/(2*dt))*2;
nfft=nfft2*2;              %   nfft multiple of 4
N=nfft*res;
N2=N/2;
N4=N/4;
ini1=round(inifr/bandw)*nfft;

% maxdop=AU/c;
pbuf=zeros(1,N);    % pos buffer  : delay N
indat=0;               % data taking
idp=N4;

r=astro2rect([direc.a direc.d],0); % size(buf),N,nbuf

p=p_eq(1,1:3);
v=v_eq(1,1:3);

p1=dot(p,r);
v1=dot(v,r);

yy0=zeros(1,N);
%npv=10
iout1=0;
last=y(1);

for i = 1:npv-1
    if round(i/10)*10 == i
        fprintf(' %d  %d  %f \n',i,indat,indat/n)
    end
    t1=(i-1)*DT+DT/2;
    t01=t0+t1/86400;
    dtEinst=tdt2tdb(t01);
    p0=p1;
    v0=v1;
    p=p_eq(i+1,1:3);
    v=v_eq(i+1,1:3);

    p1=dot(p,r); 
    v1=dot(v,r); 
    
    p=interp_pol3(p0,p1,v0,v1,N2,DT);
    pbuf(1:N2)=pbuf(N2+1:N);
    pbuf(N2+1:N)=p;
    
    yy=y(indat+1:indat+nfft);
    yy=fft(yy);
    yy0(ini1+1:ini1+nfft)=yy;
    yyy=ifft(yy0);  
    
    x=yyy(N4+1:N4+N2);
    tt=t1+(0:N2-1)*ddt+pbuf(idp+1:idp+N2)+toff+dtEinst;
    [xout, iout]=strobo([last,x],tt,dt,toff);
    nn=length(xout);
    if iout <= 0
        if -iout < nn
            xout=xout(-iout+1:length(xout));
            nn=length(xout);
            iout=1;
        else
            indat=indat+nfft2;
            continue
        end
    end
    if iout1 <= 0
        iout1=iout;
    end
    yr(iout1:iout1+nn-1)=xout;
    indat=indat+nfft2;
    iout1=iout1+nn;
    last=x(N2);
end

out.yr=yr;
toc



function p=interp_pol3(p0,p1,v0,v1,n,DT)
%
%   p0,p1,d0,d1  position and velocity (s and % of c)
%   n            number of points in the interval
%   DT           length of the interval (in s)
%
%  starts from the first point after the center of the past chunck

v0=v0*DT;
v1=v1*DT;
b(4)=p0;
b(3)=v0;
b(2)=3*(p1-p0)-(v1+2*v0);
b(1)=v1+v0-2*(p1-p0);
dx=1/n;
x=(1:n)*dx;
p=polyval(b,x);


% function p=interp_ini(p1,v1,n2,DT)
% 
% dx=(DT/n2);
% x=(-n2:-1)*dx;
% p=p1+v1*x;
% 
% 
% function p=interp_fin(p0,v0,n2,DT)
% 
% dx=(DT/n2);
% x=(0:n2-1)*dx;
% p=p0+v0*x;


function [out, iout]=strobo(x,tt,dtout,toff)
%
%   x        HF data   
%   tt       HF corrected time 
%   dtout    LF sampling time
%   toff     time bias

tt=tt/dtout;
tt1=floor(tt);
ii=find(diff(tt1));
out=x(ii+1);
% iout=round(tt(ii(1)))+1;
iout=round(tt(ii(1))*dtout-toff);