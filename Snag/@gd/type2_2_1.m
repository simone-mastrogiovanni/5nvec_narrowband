function [g1, tt, w]=type2_2_1(g2,dt,limit,icverb)
% TYPE2_2_1 approximates a type2 gd with a type1 gd
%           the g2 abscissa should be sorted 
%
%    g1=type2_2_1(g2,dt,limit)
%
%   g2      input gd
%   dt      new sampling
%   limit   number of dt to consider a hole
%   icverb  > 0 plot & c (default 1)

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('limit','var')
    limit=2;
end
if ~exist('icverb','var')
    icverb=1;
end

t0=x_gd(g2);size(t0)
n0=g2.n;
ini=t0(1);
dift0=diff(t0);
if icverb > 0
    mindift0=min(dift0);
    if mindift0 < dt
        fprintf('dt = %f seems too big: use less than %f \n',dt,mindift0)
    end
    if mindift0 > dt
        fprintf('dt*limit = %f seems too short: use limit at least %f \n',dt*limit,ceil(2*mindift0/dt))
    end
end
ii=find(floor(dift0/dt) >= limit);
ii_i=[1 ii'+1];
ii_f=[ii' n0];
ii_d=ii_f-ii_i;
iii=find(ii_d);
aiii=find(ii_d == 0);
ii_isp=ii_i(iii);
ii_fsp=ii_f(iii);
ii_soli=ii_i(aiii);

jj_i=t2jj(t0(ii_i),ini,dt);
jj_f=t2jj(t0(ii_f),ini,dt);
jj_isp=t2jj(t0(ii_isp),ini,dt);
jj_fsp=t2jj(t0(ii_fsp),ini,dt);
jj_soli=t2jj(t0(ii_soli),ini,dt);
nii=length(ii_i);
niisp=length(ii_isp);

tt=ini:dt:t0(n0);
nn=length(tt);
yy=tt*0;
w=yy; 

for i = 1:niisp
    iin=ii_isp(i):ii_fsp(i);
    y2=g2.y(iin);
    t2=t0(iin);
    jout=jj_isp(i):jj_fsp(i);
    xx=tt(jout);
    yy(jout)=spline(t2,y2,xx);
    w(jout)=1;
end

yy(jj_soli)=g2.y(ii_soli);

for i = 1:nii-1
    jout=jj_f(i)+1:jj_i(i+1);
    nout=length(jout);
    y1=yy(jj_f(i));
    y2=yy(jj_i(i+1));
    dy=(y2-y1)/nout;
    yy(jout)=(1:nout)*dy+y1;
end

% for i = 1:niisp-1
%     jout=jj_fsp(i)+1:jj_isp(i+1);
%     nout=length(jout);
%     y1=yy(jj_fsp(i));
%     y2=yy(jj_isp(i+1));
%     dy=(y2-y1)/nout;
%     yy(jout)=(1:nout)*dy+y1;
% end
    
g1=gd(yy);
g1.dx=dt;
g1.ini=t0(1);
g1.capt=[g2.capt ' -> type 1 gd'];

if icverb > 0
    figure,plot(g1);hold on,plot(g2,'r.');
end


function jj=t2jj(t,ini,dt)

jj=floor((t-ini)/dt)+1;