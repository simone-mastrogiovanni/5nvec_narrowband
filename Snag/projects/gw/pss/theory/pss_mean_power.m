function out=pss_mean_power(ant,n,sour)
%
%   ant    antenna (ex.: virgo)
%   n      [ndecl,neta npsi] or a single number (def 60)
%   sour   (if present) real amplitude respect to mean value,
%            for the whole sky and the declination

% Version 2.0 - February 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

if ~exist('n','var')
    ndecl=60;
    npsi=60;
    neta=round(npsi/4);
elseif length(n) == 1
    ndecl=n;
    npsi=n;
    neta=round(npsi/4);
else
    ndecl=n(1);
    neta=n(2);
    npsi=n(3);
end

M=zeros(ndecl,neta,npsi);
Md=zeros(ndecl,1);
Mdc=Md;
Mep=zeros(neta,npsi);
Mep_eq=Mep;
Mep_hw=Mep;
% Mep_hw1=Mep;
Mep_np=Mep;

xdecl=0:1/(ndecl-1):1;
decl=asin(xdecl)*180/pi;
decl=sort(decl);
cosiota=0:1/(neta-1):1;
eta=2*cosiota./(1+cosiota.^2);
eta=sort(eta);
psi=0:90/npsi:90-1/npsi;
[declhw,ideclhw]=min(abs(decl-30));
% declhw0=34.823;
% [declhw1,ideclhw1]=min(abs(decl-declhw0));

sour1.a=0;

for i = 1:ndecl
    sour1.d=decl(i);
    for j = 1:neta
        sour1.eta=eta(j);
        for k = 1:npsi
            sour1.psi=psi(k);  
            [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour1,ant);
            M(i,j,k)=norm(A)^2;
        end
    end
end

out.M=M;

for i = 1:ndecl
    Md(i)=mean(mean(M(i,:,:)));
    Mdc(i)=M(i,neta,1);
end

yd=Md;
meanMd=mean(Md);
Md=Md/meanMd;
meanMdc=mean(Mdc);
Mdc=Mdc/meanMdc;


for i = 1:neta
    for j = 1:npsi
        Mep(i,j)=mean(M(:,i,j));
        Mep_eq(i,j)=M(1,i,j);
        Mep_hw(i,j)=M(ideclhw,i,j);
%         Mep_hw1(i,j)=M(ideclhw1,i,j);
        Mep_np(i,j)=M(ndecl,i,j);
    end
end

Md=gd(Md);
Md=edit_gd(Md,'x',decl);
Mdc=gd(Mdc);
Mdc=edit_gd(Mdc,'x',decl);

Mep=gd2(Mep);
Mep=edit_gd2(Mep,'x',eta,'ini2',0,'dx2',90/npsi);
Mep_eq=gd2(Mep_eq);
Mep_eq=edit_gd2(Mep_eq,'x',eta,'ini2',0,'dx2',90/npsi);
Mep_hw=gd2(Mep_hw);
Mep_hw=edit_gd2(Mep_hw,'x',eta,'ini2',0,'dx2',90/npsi);
% Mep_hw1=gd2(Mep_hw1);
% Mep_hw1=edit_gd2(Mep_hw1,'x',eta,'ini2',0,'dx2',90/npsi);
Mep_np=gd2(Mep_np);
Mep_np=edit_gd2(Mep_np,'x',eta,'ini2',0,'dx2',90/npsi);

out.Md=Md;
out.meanMd=meanMd;
out.Mdc=Mdc;
out.meanMdc=meanMdc;
out.Mep=Mep;
out.Mep_eq=Mep_eq;
out.Mep_hw=Mep_hw;
% out.Mep_hw1=Mep_hw1;
out.Mep_np=Mep_np;
out.decl=decl;
out.eta=eta;
out.psi=psi;
out.mu=mean(M(:));
out.sd=std(M(:));

if exist('sour','var')
    [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,ant);
    Msour=norm(A)^2;
    dsour=abs(sour.d);
    [c,i]=min(abs(decl-dsour))
    out.sour_sky=Msour/out.mu;
    out.sour_decl=Msour/yd(i);
end

figure,plot(Md),xlabel('declination')
hold on,plot(Mdc,'r.'),title('Mean on all polarizations (b) and for circ.pol.(r.)')

plot(Mep),xlabel('eta'),ylabel('psi'),title('Mean on declination')
plot(Mep_eq),xlabel('eta'),ylabel('psi'),title('Source on celestial equator')
plot(Mep_hw),xlabel('eta'),ylabel('psi'),title('Source half way (30 deg)')
% plot(Mep_hw1),xlabel('eta'),ylabel('psi'),title('Source half way (34.823 deg)')
plot(Mep_np),xlabel('eta'),ylabel('psi'),title('Source on north pole')

plot(Mep./Mep_hw),xlabel('eta'),ylabel('psi'),title('Ratio Mean/HalfWay')
% plot(Mep./Mep_hw1),xlabel('eta'),ylabel('psi'),title('Ratio Mean/HalfWay1')