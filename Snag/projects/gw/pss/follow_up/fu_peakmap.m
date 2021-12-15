function [pm, out]=fu_peakmap(cl_sosa,fftlen,limband,thr)
% creation of follow-up peakmap
%
%   cl_sosa   cleaned sosa (source sample type 1 gd)
%   fftlen    fft length (in samples - EVEN)
%   limband   limited band
%   thr       threshold
%
%   pm        peak map structure
%   out
%      .sp    time-frequency spectrum
%      .cr    time-frequency CR
%      .fu.vfu  detector velocity
%      .fu.vvfu displaced velocities (+1 and -1 deg in alpha, +1 and -1 deg in delta) 

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

pm_band=0.1;
fu.pm_band=pm_band;
pm0=[];
if ~exist('thr','var')
    thr=2;
end

fu.fftlen=fftlen;
fu.limband=limband;
fu.thr=thr;

n=n_gd(cl_sosa);
y=y_gd(cl_sosa);
dt=dx_gd(cl_sosa);
cont=cont_gd(cl_sosa);
nn=length(cont.v);
if isfield(cont,'w')
    w=cont.w;
else
    w=zeros(3,nn);
end
t00=cont.t0;
band=1/dt;
fu.dt=dt;
fu.band=band;
limband0=mod(limband,band);    % limband in the observed band (e.g. [0.7 0.9])
fr0=limband(1)-limband0(1);    % real-observed band (e.g. 52)
obsb=0.048;
if obsb > (limband(2)-limband(1))/2
    obsb=(limband(2)-limband(1))/2-0.004
end
limband1=mod(cont.sour.f0,band)+[-obsb obsb]; % "observed" peak band (e.g. [0.7583 0.8583])
fr00=limband1(1)-limband0(1);  % e.g. 0.0583
fu.fr0=fr0;
fu.fr00=fr00;

enh=4;
mfft=enh*fftlen;
dfr=1/(dt*mfft);
fu.dfr=dfr;
mlim1=ceil(mfft*limband0(1)/band);
mlim2=ceil(mfft*limband0(2)/band);
ml=mlim2-mlim1+1;

mlim11=ceil(mfft*limband1(1)/band);
mlim12=ceil(mfft*limband1(2)/band);
m1l=mlim12-mlim11+1;
mm1=mlim11-mlim1+1; 
mm2=mlim12-mlim1+1; % mlim1,mlim2,mlim11,mlim12,mm1,mm2,m1

yy=zeros(mfft,1);
ifft2=fftlen/2;
M=0;
for i = 1:ifft2:n-fftlen
    M=M+1;
end
fu.nfft=M;
sp=zeros(M,ml);
cr=sp;
tfu=zeros(M,1);
ttfu=tfu;
vfu=tfu;
vvfu=zeros(M,4);
wfu=zeros(M,3);
m=0;
dtfft2=ifft2*dt/86400;
t0=t00+ifft2*dt/86400;
Dt=fftlen*dt/86400;
t=t0;
xx=1:ml;
win=pswindow('flatcos',fftlen); % introduced on 2-feb-2015
% win=pswindow('no',fftlen); 
% mlim1,mlim2,limband0,band,mfft,size(sp)

for i = 1:ifft2:n-fftlen
    m=m+1;
    yy(1:fftlen)=y(i:i+fftlen-1).*win';
    ss=abs(fft(yy)).^2;
    sp(m,:)=ss(mlim1:mlim2);
%     a=ypolyfit(xx,sp(m,:),4);plot(sp(m,:)),hold on,plot(a,'r'),pause(1)

% i,size(sp),mm1,mm2
    a=sp(m,:)/mean(sp(m,mm1:mm2));
    cr(m,:)=a;
    aa=a(mm1:mm2);
    ii=find(aa > a(mm1-1:mm2-1) & aa >= a(mm1+1:mm2+1) & aa >= thr);
%     ii=find(aa > a(mm1-1:mm2-1) & aa >= a(mm1+1:mm2+1));
    l=length(ii);
    pm1=zeros(5,l);
    pm1(1,:)=t;%l,size(pm1)
    pm1(2,:)=fr0+limband1(1)+dfr*(ii-1);
    pm1(3,:)=aa(ii);
    pm0=[pm0 pm1];
    
    ii=find(cont.time(1,:) >= t-dtfft2 & cont.time(1,:) < t+dtfft2);
    if length(ii) > 0
        tfu(m)=t;
        ttfu(m)=mean(cont.time(1,ii));
        vfu(m)=mean(cont.v(ii));
        for j = 1:4
            vvfu(m,j)=mean(cont.vv(j,ii));
        end
        for j = 1:3
            wfu(m,j)=mean(w(j,ii));
        end
    end
    
    t=t+Dt/2;
end

[dummy npeak]=size(pm0);
fu.npeak=npeak;
fu.dens=npeak/(M*pm_band/dfr);
fu.tfu=tfu;
fu.ttfu=ttfu;
fu.vfu=vfu;
fu.vvfu=vvfu;
fu.wfu=wfu;
fu.limband1=limband1;

pm.pm=pm0;
pm.fu=fu;
out.fu=fu;
t0=t00+ifft2*dt/86400;
Dt=fftlen*dt/86400;
sp=gd2(sp);
sp=edit_gd2(sp,'ini',t0,'dx',Dt,'ini2',limband0(1),'dx2',dfr);
out.sp=sp;
out.cr=edit_gd2(sp,'y',cr);