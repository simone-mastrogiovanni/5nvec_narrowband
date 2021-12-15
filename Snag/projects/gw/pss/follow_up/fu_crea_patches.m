function [patches,out]=fu_crea_patches(sour,tfft)
%creates patches for the follow-up
%
%    patches=fu_crea_patches(sour,tfft)
%
%    sour   source structure
%    tfft   tfft(1) first step, tfft(2) follow-up

% Version 2.0 - October 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

wsear=1.5;
out.tfft=tfft;
[lam,bet]=astro_coord('equ','ecl',sour.a,sour.d);
out.lam=lam;
out.bet=bet;
bet1=bet*pi/180;
ND=sour.f0*tfft(1)*2*1.e-4;
out.ND=ND;
dlam1=1/(ND*cos(bet1));
maxdbet=1/sqrt(ND);
dbet1=1/(ND*sin(max(abs(bet1),maxdbet)));
dlam=wsear*dlam1*180/pi;
dbet=wsear*dbet1*180/pi;
out.dlam=dlam;
out.dbet=dbet;

enh=2*round(tfft(2)/tfft(1));
out.enh=enh;
% lams=-dlam:0.7*dlam/enh:dlam;
% bets=-dbet:0.7*dbet/enh:dbet;
lams=-dlam:dlam/enh:dlam;
bets=-dbet:dbet/enh:dbet;
out.lams=lams;
out.bets=bets;

nlams=length(lams);
nbets=length(bets);
patches=zeros(nlams*nbets,5);

for i = 1:nbets
    patches((i-1)*nlams+1:i*nlams,1)=lams;
    patches((i-1)*nlams+1:i*nlams,2)=bets(i);
    patches((i-1)*nlams+1:i*nlams,3)=dlam/enh;
    patches((i-1)*nlams+1:i*nlams,4)=bets(i)+dbet/enh;
    patches((i-1)*nlams+1:i*nlams,5)=bets(i)-dbet/enh;
end