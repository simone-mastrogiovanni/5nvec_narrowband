function [R0,r0,val,R,r,err,S,s]=pss_sky_res(t,lat,bet,Nd)
%
%  t     observation times
%  lat   antenna latitude
%  bet   source beta
%  fr    frequency
%  dfr   sfdb frequency step

deg2rad=pi/180;
dlam=1;
dlamrad=dlam*deg2rad;
N=round(360/dlam);
n=length(t);
lam=zeros(1,N);
R=zeros(n,N);
R0=R;
S=R;

dt=(max(t)-min(t))*85400/(length(t)-1);


[alf,delt,v,vv,vo,vr]=earth_v2(t,0,lat);
figure,plot(t-t(1),vv),grid on

for i = 1:N
    lam(i)=i*dlam;
    [alpha,delta]=astro_coord('ecl','equ',lam(i),bet);
    sour=astro2rect([alpha,delta],0);
    [alpha,delta]=astro_coord('ecl','equ',lam(i)-dlam,bet);
    sour1=astro2rect([alpha,delta],0);
    vs=vv(:,1)*sour(1)+vv(:,2)*sour(2)+vv(:,3)*sour(3);
    vs1=vv(:,1)*sour1(1)+vv(:,2)*sour1(2)+vv(:,3)*sour1(3);
    dvs=((vs-vs1)/dlamrad)/(2*pi*Nd);
    R(:,i)=dvs;
    R0(:,i)=vs;
    S(:,i)=dvs-mean(dvs);
end

mi=min(min(R));
ma=max(max(R));
dm=(ma-mi)/250;
err=mi:dm:ma;
r=err*0;

mis=min(min(S));
mas=max(max(S));
dms=(mas-mis)/250;
ers=mis:dms:mas;
s=ers*0;

mi0=min(min(R0));
ma0=max(max(R0));
dm0=(ma0-mi0)/250;
val=mi0:dm0:ma0;
r0=val*0;

for i = 1:N
    h=hist(R(:,i),err);
    r=r+h;
    h=hist(R0(:,i),val);
    r0=r0+h;
    h=hist(S(:,i),ers);
    s=s+h;
end

figure,stairs(err,r),grid on,hold on,stairs(ers,s,'r')
figure,stairs(val,r0),grid on;
