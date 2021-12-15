function [mjd,t1,t2]=t_culm(long,rasc,t0)
% culmination time for a star (in mjd)
%
%      [mjd,t1,t2]=t_culm(long,rasc,t0)
%
%      long    longitude (deg)
%      rasc    right ascension (deg)
%      t0      raw time (mjd)
%
%   mjd  nearest time
%   t1   nearest time before
%   t2   nearest time after

% Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

culm_st=-(long-rasc)/15;

[mjd,t1,t2]=nearest_tsid(culm_st,t0);