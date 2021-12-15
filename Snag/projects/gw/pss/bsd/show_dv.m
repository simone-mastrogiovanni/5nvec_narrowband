function [dv,DV]=show_dv(spotstr,k,check) 
% show dvtot from bsd_hspot_fu %
%      dv=show_dv(k,nl,nb,dvtot)
%
%   k       the peak serial number
%   nl,nb   number of lambdas and betas
%   dvtot   total velocity variation

% Snag Version 2.0 - April 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas 
% by S.D'Antonio, O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it 
% Department of Physics - Sapienza University - Rome

dv=spotstr.dvtot(:,k);
lam=spotstr.lam;
nl=length(lam);
lam0=spotstr.lam0;
bet=spotstr.bet;
nb=length(bet);
bet0=spotstr.bet0;
smap=spotstr.smap;

cont=spotstr.cont;

dv=reshape(dv,nb,nl);

dlam=spotstr.lam(2)-spotstr.lam(1);

dv=gd2(dv);
dv=edit_gd2(dv,'ini2',spotstr.lam(1)-lam0,'dx2',dlam,'x',spotstr.bet-bet0);
plot(dv),title(sprintf('dv  peak %d',k)),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on

plot(abs(dv)),title(sprintf('abs(dv)  peak %d',k)),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on

t0=cont.t0;
TP=check.checkG.peatot(1,:);
TP=unique(TP);
tvel=diff_mjd(t0,TP(k));
%tvel=diff_mjd(t0,spotstr.peaks_par.Tvel_pt(k));

vx=interp1(cont.v_eq(:,4),cont.v_eq(:,1),tvel);
vy=interp1(cont.v_eq(:,4),cont.v_eq(:,2),tvel);
vz=interp1(cont.v_eq(:,4),cont.v_eq(:,3),tvel);
vv=[vx vy vz];

[n,~]=size(smap);
v=zeros(n,1);
whos vv
whos r1

for i = 1:n
     lam1=smap(i,1);
     bet1=smap(i,2);
     [a,d]=astro_coord('ecl','equ',lam1,bet1);
     r1=astro2rect([a d],0);
     v(i)=dot(vv,r1);
end
[a,d]=astro_coord('ecl','equ',lam0,bet0);
r1=astro2rect([a d],0);
v0=dot(vv,r1);

DV=v-v0;
DV=reshape(DV,nb,nl);
DV=gd2(DV);
DV=edit_gd2(DV,'ini2',spotstr.lam(1)-lam0,'dx2',dlam,'x',spotstr.bet-bet0);
plot(DV),title(sprintf('DV  peak %d',k)),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on

plot(abs(DV)),title(sprintf('abs(DV)  peak %d',k)),ylabel(sprintf('lam - %.2f',lam0)),xlabel(sprintf('bet - %.2f',bet0)),grid on

