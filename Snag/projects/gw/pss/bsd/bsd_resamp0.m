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
buf=zeros(1,lbuf);     % data buffer : delay N2
pbuf=zeros(1,lbuf);    % pos buffer  : delay N
dpbuf=pbuf;            % differential pos buffer  : lilo
indat=0;               % data taking
inpbuf=0;              % buffers charging
outbuf=0;
lobuf=nbuf*nfft2;
idp=(nbuf-nbuf1-1)*N2+N4;
obuf=zeros(1,lobuf);
% buffer data extraction
% inpbuf=N;              % 

r=astro2rect([direc.a direc.d],0); % size(buf),N,nbuf

p=p_eq(1,1:3);
v=v_eq(1,1:3);

p1=dot(p,r);
v1=dot(v,r);

it0=0;
icont=1;
out=[];   npv=10

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
    pbuf(N+1:lbuf)=round(p/ddt);
    dpbuf(1:N)=dpbuf(N2+1:lbuf);
    dpbuf(N+2:lbuf)=diff(pbuf(N+1:lbuf));
    dpbuf(N+1)=pbuf(N+1)-pbuf(N);
    iii=find(dpbuf(idp+1:idp+N2));
    vvv=dpbuf(idp+iii);
    
    tini=p0;
    ini=round(tini/ddt);
    it1=it0-ini;
    it1s=round(it1/res);
%     mit1=mod(it1,lbuf);
    iiii=[iii N2+1];
    ind0=lbuf-N2;
    ind=ind0;
    
%     dp1=diff(p1);
    yy=y(indat+1:indat+nfft);
    yy=fft(yy);
    yy(nfft+1:N)=0;
    yy=ifft(yy);  % length(yy)
%     out=[out yy(N4+1:N4+N2)'];
    buf(1:N)=buf(N2+1:lbuf);
    buf(N+1:lbuf)=yy(N4+1:N4+N2);
    
    if it1s > 0 && it1s < n
        for j = 1:length(iii)
%             ind,ind0,iii(j),size(buf)
            aa=buf(ind:res:ind0+iii(j)); 
            yr(it1s:it1s+floor(iii(j)/res))=aa;
            ind=ind0+iii(j);
            if vvv(j) > 0
                xx=-1;
            else
                xx=1;
            end
            it1s=it1s+length(aa)+xx;
        end
    end
    icont=2;
    indat=indat+nfft2;
    inpbuf=inpbuf+N;
    it0=it0+N2;
end

out.N=N;
out.inpbuf=inpbuf;
out.buf=buf;
out.pbuf=pbuf;
out.dpbuf=dpbuf;
out.iii=iii;
out.vvv=vvv;
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
iout=round(tt(ii(1)));