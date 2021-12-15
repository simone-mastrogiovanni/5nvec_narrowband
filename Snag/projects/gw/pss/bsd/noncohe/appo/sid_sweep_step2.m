function sids2=sid_sweep_step2(addr,ant,runame,freq,direc,wband,sband,icflat,frbase)
% analyze candidates of sid_sweep procedure
%
%   sids=sid_sweep(tab,direc,wband,wband0)
%
%   addr,ant,runame  as for bsd_lego
%   freq    candidate frequency
%   direc   direction structure
%   wband   sub-band division (0.5,1,2,5,10 Hz; typically 1 Hz)
%   sband   search band (in units of 1/SD; typically 10)
%   icflat  >0 flat weights (def 0)
%   frbase  basic bsd frequency (def 10)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
nsid=120;
enl=10;

tic

if ~exist('icflat','var')
    icflat=0;
end

if ~exist('frbase','var')
    frbase=10;
end

if icflat <= 0
    sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
    weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
    weig=weig/mean(weig);
else
    weig=ones(4,1);
end

sids2.weig=weig;