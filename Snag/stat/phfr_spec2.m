function [g2 map asp]=phfr_spec2(g2in,fr,capt,subband,nbin,nofig,res)
% phfr_spec2 phase-frequency map and spectrum from t-f gd2
%            performed by epoch folding
%
%      g2=phfr_spec2(g2in,fr)
% 
%    g2in     time-frequency gd2 (zeroes are considered omitted data)
%    fr       frequencies (equispaced); if length(fr)=1, 2*fr frequencies around 1 are computed
%    capt
%    subband  [minfr maxfr] ; =0 all
%    nofig    1 -> no output figure, 2 -> no per out
%    res      resolution (default 8)

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if  ~exist('capt','var')
    capt='';
end

capt=underscore_man(capt);

if  ~exist('subband','var')
    subband=0;
end

if  ~exist('nbin','var')
    nbin=120;
end

if  ~exist('nofig','var')
    nofig=0;
end

if  ~exist('res','var')
    res=8;
end

SF=1.002737909350795;

t=x_gd2(g2in);
t0=round(mean(t));
t=t-t0;
T=max(t)-min(t);
g2in=edit_gd2(g2in,'x',t);
 
if length(fr) == 1
    kk=ceil(res*T/365.25)
    dfr=(SF-1)/kk;
    N=fr;
    fr0=1-dfr*N;
    fr=fr0+(0:2*N)*dfr;
else
    fr0=fr(1);
    dfr=fr(2)-fr(1);
end

for i = 1:length(fr)
    [periods percleans win perpar meanper]=gd2_period(g2in,1/fr(i),0,nbin,subband,nofig);
    pers(i,:)=meanper(3,:);
end

g2=gd2(pers');
g2=edit_gd2(g2,'ini2',fr0,'dx2',dfr,'dx',0.2);

[map asp]=elab_perspec(g2,0,0,capt);