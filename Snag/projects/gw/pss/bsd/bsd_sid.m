function out=bsd_sid(in,sour,nsid,modif)
% sidereal analysis (gmst)
%
%   in     input bsd (ftrimmed)
%   sour   source (alpha and fr)
%   nsid   number of sidereal bins 
%   modif  modifier (for check)  1 day, 7 week; if absent or 0 sidereal day

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

global bsd_glob_noplot

SD=86164.09053083288;

fr=sour.f0;
alf=sour.a;

ant=bsd_ant(in);
long=ant.long;

if exist('mod','var')
    if mod == 1
        SD=86400;
    elseif mod == 7
        SD=86400*7;
    elseif mod > 0
        SD=86400*mod;
    end
end

dt=dx_gd(in);
n=n_gd(in);
ini=ini_gd(in);
y=y_gd(in);
cont=ccont_gd(in);
eval(['ant=' cont.ant ';']);
t0=cont.t0;
inifr=cont.inifr;
st0=loc_sidtim(t0,ant.long)-alf/15;
T0=n*dt;

t=(0:n-1)'*dt;
y=y.*exp(-1j*(fr-inifr)*2*pi*t);
ay=abs(y);
py=ay.^2; 

t=mod(t+st0*3600,SD);
t=floor(t*nsid/SD)+1;

ww=zeros(1,nsid);
yy=ww;
aa=ww;
pp=ww;

for i = 1:nsid
    i1=find(t == i);
    pp(i)=mean(py(i1));
    aa(i)=mean(ay(i1));
    yy(i)=mean(y(i1));
    ww(i)=mean(sign(ay(i1)));
end

out.pow=pp./ww;
out.abs=aa./ww;
out.val=yy./ww;
out.win=ww;
out.xx=(0:nsid-1)*24/nsid;

ff=fft(out.pow);
out.harm=ff(1:21);
nf=length(ff);
nf2=floor(nf/2);

if bsd_glob_noplot == 0
    figure,plot(out.xx,out.pow),grid on,hold on,plot(out.xx,out.pow,'r.')
    title('Normalized Power'),xlabel('Local Sidereal Hours')
    figure,plot(out.xx,out.win),grid on,hold on,plot(out.xx,out.win,'r.')
    title('Observation window'),xlabel('Local Sidereal Hours')
    figure,semilogy(0:20,abs(out.harm).^2/abs(out.harm(1)).^2,'x'),grid on
    title('Harmonics normalized power'),xlabel('Local Sidereal Harmonics')
end

out.datrat=sum(abs(ff(2:5)).^2/sum(abs(ff(6:21)).^2))*(16/4);
out.gendatrat=sum(abs(ff(2:5)).^2/sum(abs(ff(6:nf2)).^2))*((nf2-5)/4);
fprintf('Detection ratio %f   gen.det.rat.: %f \n',out.datrat,out.gendatrat)

% figure,plot(out.xx,out.abs),grid on,hold on,plot(out.xx,out.abs,'r.')
% plot(out.xx,abs(out.val),'r'),plot(out.xx,abs(out.val),'b.')