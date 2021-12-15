function [p,v,t,dp,dv,ps,vs,tt]=interp_VP(VPstr,sour,t)
% position and velocity interpolation
%
%   [p,v,t,dv,ps,ps,vs,tt]=interp_VP(VPstr,sour,t)
%
%   VP       VP array or structure
%   sour     updated (by new_frpos) targeted source
%   t        (if not given by gd)
% %   einst    = 1 -> corrects also Einstein effect
%
%   p,v,t    position, speed and time respect to sour
%   dp,dv    position and speed derivatives (dlam, dbet1 (up), dbet2)
%   ps,vs,tt original values

% Version 2.0 - June 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('einst','var')
    einst=0;
end

VP=VPstr.VP;
dt=VPstr.dt;
n=VPstr.n;
t0=VPstr.t0;
[nfft,dummy]=size(VP);
p=zeros(n,1);
v=p;
indgd=zeros(nfft,1);

op=1; % beginning
tt=VP(:,8);
vv=VP(:,2:4);
pp=VP(:,5:7);

if isfield(sour,'fepoch')
    sour=new_posfr(sour,t0);
end

if isfield(sour,'lam')
    lam=sour.lam;
    bet=sour.bet;
    if ~isfield(sour,'a')
        [sour.a,sour.d]=astro_coord('ecl','equ',lam,bet);
    end
else
    [lam,bet]=astro_coord('equ','ecl',sour.a,sour.d);
end
r=astro2rect([sour.a sour.d],0);
r=repmat(r,nfft,1);
% f0=sour.f0;

vs=dot(vv,r,2); 
ps=dot(pp,r,2);

DT=tt(1);
i1=1;
i2=round(tt(1)/dt)+1;
T=((i1-1)*dt:dt:(i2-1)*dt)/DT;
T=T-T(i2);
p1=ps(1);
v1=vs(1);
[p(i1:i2),v(i1:i2)]=interp_ini(p1,v1,T,DT);

for i = 1:nfft-1
    DT=tt(i+1)-tt(i);
    i1=round(tt(i)/dt)+1;
    i2=round(tt(i+1)/dt)+1;
    indgd(i)=i1;
    T=((i1-1)*dt:dt:(i2-1)*dt)/DT;
    T=T-T(1);
    p0=ps(i);
    p1=ps(i+1);
    v0=vs(i);
    v1=vs(i+1);
    [p(i1:i2),v(i1:i2)]=interp_pol3(p0,p1,v0,v1,T,DT);
end

% DT=dt*nfft-tt(nfft); CORRETTO DA SIMONE
DT=dt*n-tt(nfft);
i1=round(tt(nfft)/dt)+1;
i2=n;
T=((i1-1)*dt:dt:(i2-1)*dt)/DT;
T=T-T(1);
p0=ps(nfft);
v0=vs(nfft);
[p(i1:i2),v(i1:i2)]=interp_fin(p0,v0,T,DT);

t1=0:dt:(n-0.99)*dt;
if exist('t','var')
    t=diff_mjd(t0,t);
    p=interp1(t1,p,t);
    v=interp1(t1,v,t);
else
    t=t1;
end

if nargout > 3
    t2=0:dt:(nfft-0.99)*dt;
    lam1=lam+1;bet1=bet;
    lam2=lam;bet2=bet+1;
    lam3=lam;bet3=bet-1;

    [a,d]=astro_coord('ecl','equ',lam1,bet1);
    r1=astro2rect([a d],0);
    r1=repmat(r1,nfft,1);
    [a,d]=astro_coord('ecl','equ',lam2,bet2);
    r2=astro2rect([a d],0);
    r2=repmat(r2,nfft,1);
    [a,d]=astro_coord('ecl','equ',lam3,bet3);
    r3=astro2rect([a,d],0);
    r3=repmat(r3,nfft,1);

    
    dvs1=dot(vv,r1,2)-vs;size(t),size(t1),size(dvs1)
    dps1=dot(pp,r1,2)-ps;
    dvs2=dot(vv,r2,2)-vs;
    dps2=dot(pp,r2,2)-ps;
    dvs3=vs-dot(vv,r3,2);
    dps3=ps-dot(pp,r3,2); 
    
    len1=length(dvs1);
    len2=length(t);
    nl=round(len1/len2);
    i1=1;
    i2=i1+nl;
    
    for i = 1:len2
        dp(1,i)=mean(dps1(i1:i2));
        dv(1,i)=mean(dvs1(i1:i2));
        dp(2,i)=mean(dps2(i1:i2));
        dv(2,i)=mean(dvs2(i1:i2));
        dp(3,i)=mean(dps3(i1:i2));
        dv(3,i)=mean(dvs3(i1:i2));
        i1=i2+1;
        i2=min(i1+nl,len1);
        if i1 > i2
            i1=i2;
        end
    end
%     size(dv),iii=find(isnan(dvs1))
end




function [p,v]=interp_pol3(p0,p1,v0,v1,T,DT)
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
p=polyval(b,T);

c(3)=b(3);
c(2)=2*b(2);
c(1)=3*b(1);
v=polyval(c,T)/DT;



function [p,v]=interp_ini(p1,v1,T,DT)

v1=v1/DT;
p=p1+v1*T;
v=p*0+v1*DT;



function [p,v]=interp_fin(p0,v0,T,DT)

v0=v0/DT;
p=p0+v0*T;
v=p*0+v0*DT;
