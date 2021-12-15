function sourupd=new_posfr_2(sour,t)
% NEW_POSFR  recomputes position and frequency
%
%       sourupd=new_posfr(sour,t)
%
%   sour    source structure
%   t       time (mjd)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit? "Sapienza" - Rome
%
% C. Palomba: Further frequency derivatives added (Apr. 2011)

sourupd=sour;
sourupd.pepoch=t;
sourupd.fepoch=t;

if isfield(sour,'d3f0') == 0
    sour.d3f0=0;
end
if isfield(sour,'d4f0') == 0
    sour.d4f0=0;
end
if isfield(sour,'d5f0') == 0
    sour.d5f0=0;
end
if isfield(sour,'d6f0') == 0
    sour.d6f0=0;
end
if isfield(sour,'d7f0') == 0
    sour.d7f0=0;
end

% DT=t-sour.fepoch;
DT=diff_mjd(sour.fepoch,t)/86400;
sourupd.f0=sour.d7f0*(DT*86400)^7/5040+sour.d6f0*(DT*86400)^6/720+sour.d5f0*(DT*86400)^5/120+sour.d4f0*(DT*86400)^4/24+...
    sour.d3f0*(DT*86400)^3/6+sour.ddf0*(DT*86400)^2/2+sour.df0*DT*86400+sour.f0;
sourupd.df0=sour.d7f0*(DT*86400)^6/720+sour.d6f0*(DT*86400)^5/120+sour.d5f0*(DT*86400)^4/24+sour.d4f0*(DT*86400)^3/6+...
    sour.d3f0*(DT*86400)^2/2+sour.ddf0*DT*86400+sour.df0;
sourupd.ddf0=sour.d7f0*(DT*86400)^5/120+sour.d6f0*(DT*86400)^4/24+sour.d5f0*(DT*86400)^3/6+sour.d4f0*(DT*86400)^2/2+...
    sour.d3f0*DT*86400+sour.ddf0;
sourupd.d3f0=sour.d7f0*(DT*86400)^4/24+sour.d6f0*(DT*86400)^3/6+sour.d5f0*(DT*86400)^2/2+sour.d4f0*DT*86400+sour.d3f0;
sourupd.d4f0=sour.d7f0*(DT*86400)^3/6+sour.d6f0*(DT*86400)^2/2+sour.d5f0*DT*86400+sour.d4f0;
sourupd.d5f0=sour.d7f0*(DT*86400)^2/2+sour.d6f0*DT*86400+sour.d5f0;
sourupd.d6f0=sour.d7f0*DT*86400+sour.d6f0;
sourupd.d7f0=sour.d7f0;

% DT=t-sour.pepoch;
DT=diff_mjd(sour.pepoch,t)/86400;
sourupd.a=sour.a+sour.v_a*DT/(365.25*1000*3600);
sourupd.d=sour.d+sour.v_d*DT/(365.25*1000*3600);
