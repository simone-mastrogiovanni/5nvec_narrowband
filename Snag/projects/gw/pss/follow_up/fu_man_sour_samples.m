function out=fu_man_sour_samples(sosa,basic_info,thresh)
% source corrected samples management
%
%    out=fu_man_sour_samples(sosa,basic_info,thresh)
%
%   sosa
%   basic_info
%   thresh       threshold to cut peaks
%
%   out=fu_man_sour_samples(sosa,basic_info,thresh)

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('thresh','var')
    thresh=0.04;
end
dt=dx_gd(sosa);
cont=cont_gd(sosa);
t0=cont.t0;
sour=cont.sour;
epoch=sour.fepoch;

tim=basic_info.tim;
vel=basic_info.velpos;
dtim=spline(cont.time(1,:),cont.time(2,:),tim);
newtim=tim+dtim/86400;

r=astro2rect([sour.a,sour.d],0);
v=vel(1:3,:);
Nt=basic_info.ntim;
v1=zeros(1,Nt);

sour=new_posfr(sour,epoch);
fr0=sour.f0;
sd=sour.df0;
fr1=fr0+tim*sd;
alpha=sour.a;
delta=sour.d;
r=astro2rect([alpha,delta],0);

for i = 1:Nt
    v1(i)=dot(v(:,i),r);
end

fr1=fr1.*(1+v1);

% for i = 1:Nt
%     fr=ptin(2,index(i):index(i+1)-1);
%     ii=find(abs(fr-fr1(i)) < dfr*1.5);
%     nii=length(ii);
%     if nii > 0
%         ptcl(4,index(i)-1+ii)=0;
%         nveto_sour=nveto_sour+nii;
%     end
% end
    
gsp=basic_info.gsp;
sp=y_gd2(gsp);
inisp=ini2_gd2(gsp);
dfsp=dx2_gd2(gsp);
[m1,m2]=size(sp);
wien1=fr1*0;

excl=2/3;
wien=sp*0;
for i = 1:m2
    sp1=sp(:,i);
    m=median(sp1);
    ii=find(sp1 < excl*m);
    sp1(ii)=0;
    jj=find(sp1);
    sp1=1./sp1(jj);
    wien(jj,i)=sp1/mean(sp1);
end

ii=round((fr1-inisp)/dfsp)+1;

for i = 1:m1
    wien1(i)=wien(i,ii(i));
end

wien1=gd(wien1);
wien1=edit_gd(wien1,'x',(newtim-newtim(1))*86400);
[wien2, tt, w]=type2_2_1(wien1,dt,10000,2);
w=y_gd(wien2);
jj=find(w < 1/4);
w(jj)=0;size(w),size(y_gd(sosa))

% sp=sp.*iewien;
% wsp=zeros(1,m2);
% for i = 1:m2
%     wsp(i)=sum(sp(:,i))/sum(wien(:,i));
% end
% wsp=gd(wsp);
% wsp=edit_gd(wsp,'ini',inisp,'dx',dfsp);

ysosa=y_gd(sosa);
x=(0:200)*thresh/200;
h=hist(abs(ysosa),x);
figure,stairs(x,h),grid on
jj=find(abs(ysosa)>thresh);
ysosa(jj)=0;
sosa=edit_gd(sosa,'y',ysosa);

figure,plot(cont.vv(1,:)-cont.v,'.'),grid on,hold on
plot(cont.vv(2,:)-cont.v,'c.'),plot(cont.vv(3,:)-cont.v,'r.'),plot(cont.vv(4,:)-cont.v,'m.')

figure,plot((cont.vv(1,:)-cont.v)./max(abs(cont.v)),'.'),grid on

out.tim=tim;
% out.wsp=wsp;
out.gsp=gsp;
out.wien=wien;
out.fr=fr1;
out.ii=ii;
out.wien1=wien1;
out.wien2=wien2;
out.newtim=newtim;
out.sosaw=sosa(1:length(w)).*w;   % CORRECT !!!
out.sosa=sosa;