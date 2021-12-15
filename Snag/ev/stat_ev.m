function chstr=stat_ev(evch,lh)
%STAT_EV  statistics for events
%
%   lh    number of histogram bins

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ewyes=0;
if isfield(evch,'ew')
    ewyes=1;
else
    evch.ew=ev2ew(evch.ev);
end

if ~exist('lh')
    lh=50;
end

nchtot=length(evch.ch.an);
nch=evch.ch.nch;

chstr=evch.ch;
hista=zeros(nchtot,lh);
histcr=hista;
histl=hista;

ch=evch.ew.ch;

for j = 1:nchtot
    ii=find(ch == j);
    a=evch.ew.a(ii);
    cr=evch.ew.cr(ii);
    l=evch.ew.l(ii);
    minea(j)=min(a);
    maxea(j)=max(a);
    minecr(j)=min(cr);
    maxecr(j)=max(cr);
    minel(j)=min(l);
    maxel(j)=max(l);
end

minea0=min(minea);
maxea0=max(maxea);
minecr0=min(minecr);
maxecr0=max(maxecr);
minel0=min(minel);
maxel0=max(maxel);

xa=(0:lh-1)*(maxea0-minea0)/lh+minea0;
xcr=(0:lh-1)*(maxecr0-minecr0)/lh+minecr0;
xl=(0:lh-1)*(maxel0-minel0)/lh+minel0;

for j = 1:nchtot
    ii=find(ch == j);
    a=evch.ew.a(ii);
    cr=evch.ew.cr(ii);
    l=evch.ew.l(ii);
    hista(j,:)=hist(a,xa);
    histcr(j,:)=hist(cr,xcr);
    histl(j,:)=hist(l,xl);
end

chstr.minha=minea;
chstr.dha=(maxea-minea)/lh;
chstr.hista=hista;
chstr.minhcr=minecr;
chstr.dhcr=(maxecr-minecr)/lh;
chstr.histcr=histcr;
chstr.minhl=minel;
chstr.dhl=(maxel-minel)/lh;
chstr.histl=histl;

figure,stairs(xa,log10(hista')),grid on, zoom on, xlabel('Amplitude')
figure,stairs(xcr,log10(histcr')),grid on, zoom on, xlabel('Critical Ratio')
figure,stairs(xl,log10(histl')),grid on, zoom on, xlabel('Length (s)')

