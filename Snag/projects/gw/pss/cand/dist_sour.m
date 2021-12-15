function [ii,dd,d1,d2,d3,d4]=dist_sour(sour,cands,dmax,dfr,dsd)
% source-candidates distance
%
%      [ii,dd,d1,d2,d3,d4]=dist_sour(sour,cands,dmax,dfr,dsd)
%
%   sour     source (10 pars)
%   cands    candidates (9 pars)
%   dmax     max distance
%   dfr,dsd  parameters
%
%   ii       neighboring cands indices
%   dd       all the distances

% Snag Version 2.0 - May 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[dd,d1,d2,d3,d4]=distance_4_sour(sour,cands,dfr,dsd);

ii=find(dd < dmax);

d1=d1(ii);
d2=d2(ii);
d3=d3(ii);
d4=d4(ii);