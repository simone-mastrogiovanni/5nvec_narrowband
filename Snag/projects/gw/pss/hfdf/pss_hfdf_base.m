function hm=pss_hfdf_base(pm,time,doparr,hfdfstr)
% PSS_HFDF_BASE  basic hfdf operation
%
%    hm=pss_hfdf_base(pm,time,hfdfstr,dopmat)
%
%   pm       peak list (2,n): each peak has time index and frequency index
%              data should be sorted ascending, for both indices
%   time     time for each index (mjd)
%   doparr   Doppler array with, for a given source, per each time index 
%              there is the % freq. shift
%   hfdfstr  hfdf structure. Contains:
%     .inifr    min freq
%     .dfr      freq bin
%     .nfr      number of frequency bins
%     .res      frequency resolution (integer)
%     .inisd    min spin-down value (Hz/s; max 0) (the spin-down is positive) 
%     .dsd      spin-down bin (Hz/s)
%     .nsd      number of s.d. values
%
%   hm(nfr*res,nsd)  Hough map

% Version 2.0 - April 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[i2,np]=size(pm);
nt=length(time);
nsd=hfdfstr.nsd;
inisd=hfdfstr.inisd;

ibias=zeros(1,nt+1);
[i1,i2]=find(diff(pm(1,:)));
ibias(1)=0;
ibias(2:nt)=i2;
ibias(nt+1)=np;

Res=hfdfstr.res;
Dt=(time(nt)-time(1))*86400;
Band0=hfdfstr.dfr*(hfdfstr.nfr-1);
Maxfr=hfdfstr.inifr+Band0;
Maxsd=inisd+hfdfstr.dsd*(nsd-1);
Dfr=hfdfstr.dfr/Res;
preBand=ceil(1.0001*hfdfstr.inifr/Dfr)+10;
postBand=ceil((1.0001*Maxfr-inisd*Dt)/Dfr)+10;
Nfr=Band0/Dfr+1+preBand+postBand;
df=Dt*hfdfstr.dsd/Dfr; % in fractional freq bins

hm=zeros(Nfr,hfdfstr.nsd);
% hm=hm(:);
% bias2=(0:nsd-1)*Nfr;
dopbini=doparr*hfdfstr.inifr/Dfr;
dopbd=doparr*(Maxfr-hfdfstr.inifr)/Dfr;

for i = 1:nt
    nn=ibias(i+1)-ibias(i);
    f0=pm(2,ibias(i)+1:ibias(i+1))*Res-dopbini(i)-dopbd(i)*(0:nn-1);
    for j = 1:nn
        i1=round(f0(j)-(1:nsd)*df-inisd);
        for k = 1:nsd
            i1k=i1(k);
            hm(i1k:i1k+res-1,k)=hm(i1k:i1k+res-1,k)+1;
        end
    end
end