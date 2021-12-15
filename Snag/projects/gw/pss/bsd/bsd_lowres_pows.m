function [s,pieces,lenpiec]=bsd_lowres_pows(bsd,res,lcohe,windn)
% low resolution spectrum
%
%      s=bsd_lowres_pows(bsd,res,lcohe,windn)
%
%   bsd    input bsd
%   res    0-padding resolution enhancement
%   lcohe  coherence length (days or s)
%   windn   window number (0 -> no, 1 -> bartlett, 2 -> hanning, 3 -> flatcos, 4 -> tukey)
%            def hanning

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if lcohe > 1000
    lcohe=lcohe/86400;
    disp('lcohe in s')
else
    disp('lcohe in days')
end

if ~exist('windn','var')
    windn=2;
end

n=n_gd(bsd);
dt=dx_gd(bsd);
T0=n*dt;
pieces=floor(T0/(lcohe*86400));
if pieces < 1
    pieces=1;
end

fprintf(' %d pieces \n',pieces)
lenpiec=floor(n/pieces);

s=bsd_pows(bsd,res,pieces,windn);