function sourupd=new_posfr(sour,t)
% NEW_POSFR  recomputes position and frequency
%
%       sourupd=new_posfr(sour,t)
%
%   sour    source structure
%   t       time (mjd)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

sourupd=sour;

if isfield(sour,'fepoch')
    sourupd.fepoch=t;
    % DT=t-sour.fepoch;
    DT=diff_mjd(sour.fepoch,t);
    sourupd.f0=sour.f0+sour.df0*DT+sour.ddf0*DT^2/2;
    sourupd.df0=sour.df0+sour.ddf0*DT;
else
    disp('no fepoch info')
end

if isfield(sour,'pepoch')
    sourupd.pepoch=t;
    % DT=t-sour.pepoch;
    DT=diff_mjd(sour.pepoch,t);
    sourupd.a=sour.a+sour.v_a*DT/(365.25*1000*3600*86400);
    sourupd.d=sour.d+sour.v_d*DT/(365.25*1000*3600*86400);
else
    disp('no pepoch info')
end