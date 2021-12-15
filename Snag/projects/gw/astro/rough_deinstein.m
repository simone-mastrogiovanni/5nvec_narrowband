function [ein tein]=rough_deinstein(t)
% ROUGH_DEINSTEIN  computes roughly the einstein effect
%                  (it is correct in doptabs)
%
%     t     time (in mjd)

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

amp=3.35677338e-010;
amp1=1.1149425e-011/2;%amp1=0
year=365.25;
phas=2.347222*2*pi/year;
tt=mod(t-54832,year);
ein=(amp-amp1)*cos(tt*2*pi/year-phas)+amp1*cos(tt*4*pi/year-phas*2);
if length(t) > 1
    tein=cumsum(ein(2:length(ein)).*diff(t)*86400);
else
    tein=0;
end