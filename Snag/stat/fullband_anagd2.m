function [ps psls psef]=fullband_anagd2(g2in,subband,fr,res,flags,capt)
% fullband_anagd2 various spectra on the data of the full band
%    spectra:   1 Power spectrum
%               2 Lomb-Scargle spectrum
%               3 Epoch-folding spectrum on
%
%     [ps psls psef]=fullband_anagd2(g2in,subband,fr,res,flags,capt
% 
%    g2in      time-frequency gd2 (zeroes are considered omitted data)
%    subband   [minfr maxfr] ; =0 all
%    fr        [min max] frequencies (equispaced); if length(fr)=1, 2*fr frequencies around 1 are computed
%    res       resolution (default 8)
%    flags(3)  flags on the 3 procedures (def 1; if length(flags)==1, indicates the only one to be set)
%    capt

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n ini dx m ini2 dx2 type]=par_gd2(g2in);

NP=120;
ps=0;psls=0;psef=0;

if  ~exist('flags','var')
    flags=[1 1 1];
end

if  length(flags) == 1
    flag=flags;
    flags=[0 0 0];
    if flag > 0 & flag < 4
       flags(flag)=1;
    end
end

if  ~exist('capt','var')
    capt='';
end

capt=underscore_man(capt);

if  ~exist('subband','var') || subband == 0
    i2(1)=1;
    i2(2)=m;
else
    i2(1)=(subband(1)-ini2)/dx2+1;
    i2(2)=(subband(2)-ini2)/dx2+1;
end

if  ~exist('nofig','var')
    nofig=0;
end

if  ~exist('res','var')
    res=8;
end

SF=1.002737909350795;

% t=x_gd2(g2in);
% t0=round(mean(t));
% t=t-t0;
% T=max(t)-min(t);
% g2in=edit_gd2(g2in,'x',t);
%  
% if length(fr) == 1
%     kk=ceil(res*T/365.25)
%     dfr=(SF-1)/kk;
%     N=fr;
%     fr0=1-dfr*N;
%     fr=fr0+(0:2*N)*dfr;
% else
%     fr0=fr(1);
%     dfr=fr(2)-fr(1);
% end

g1=gd2_to_gd_norm(g2in,0,i2);

t=x_gd(g1);
% t0=round(mean(t));
% t=t-t0;
T=max(t)-min(t);

dfr=1/(T*res);

if flags(1) > 0
    g1=g1/std(g1);
    ps=gd_holeps(g1,fr(1),fr(2),dfr);['Power spectrum on ' capt]
    show_spec_lines(ps,['Power spectrum on ' capt])
end

if flags(2) > 0
    [psls prob]=lombscargle(g1,1,res,fr(2),0);
    show_spec_lines(psls,['Lomb-Scargle spectrum on ' capt])
end

if flags(3) > 0
    [sp1 sp4 spall ft]=gd_nud_spec(g1,fr,res,NP);
    show_spec_lines(sp1,['Epoch-folding spectrum on ' capt])
end
    