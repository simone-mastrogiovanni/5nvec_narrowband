function out=bsd_resamp1(in,direc,res)
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

AU=149597870700;
c=	299792458;

if ~exist('res','var')
    res=200;
end

cont=ccont_gd(in);
p_eq=cont.p_eq;
v_eq=cont.v_eq;
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
N4=N/4; N4
maxdop=AU/c;
nbuf1=ceil(maxdop*1.05/DT);
nbuf=nbuf1*2+1;
lbuf=nbuf*N2;
pbuf=zeros(1,lbuf);    % pos buffer  : delay N
indat=0;               % data taking
lobuf=nbuf*nfft2;
idp=(nbuf-nbuf1-1)*N2+N4;

r=astro2rect([direc.a direc.d],0); % size(buf),N,nbuf

p=p_eq(1,1:3);
v=v_eq(1,1:3);

p1=dot(p,r);
v1=dot(v,r);

%npv=10
iout1=0;

for i = 1:npv-1
    if round(i/10)*10 == i
        fprintf(' %d  %d  %f \n',i,indat,indat/n)
    end
    p0=p1;
    v0=v1;
    p=p_eq(i+1,1:3);
    v=v_eq(i+1,1:3);

    p1=dot(p,r); 
    v1=dot(v,r); 
    
    p=interp_pol3(p0,p1,v0,v1,N2,DT);
    pbuf(1:N)=pbuf(N2+1:lbuf);
    pbuf(N+1:lbuf)=p;
    
    yy=y(indat+1:indat+nfft);
    yy=fft(yy);
    yy(nfft+1:N)=0;
    yy=ifft(yy);  
    
    x=yy(N4+1:N4+N2);
    tt=(0:N2-1)*ddt+pbuf(idp+1:idp+N2);
    [xout, iout]=strobo(x,tt,dt,0);
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


function p=interp_ini(p1,v1,n2,DT)

dx=(DT/n2);
x=(-n2:-1)*dx;
p=p1+v1*x;


function p=interp_fin(p0,v0,n2,DT)

dx=(DT/n2);
x=(0:n2-1)*dx;
p=p0+v0*x;


function [out iout]=strobo(x,tt,dtout,toff)
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