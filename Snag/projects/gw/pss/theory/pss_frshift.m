function fr=pss_frshift(t,source,antdop)
% PSS_FRSHIFT  computes the shifted frequency with simple or precise method
%
%   t         time array (mjd)
%   source    structures
%   antdop    antenna structure (approx method) or Doppler table (precise)

% Version 2.0 - February 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(antdop,'double')
    ic=1;
    dop=gw_doppler(antdop,source,t);
else
    ic=2;
    dop=gw_doppler_simp(source,antdop,t);
end

if isfield(source,'tt0')
    t00=source.tt0;
else
    t00=v2mjd([2000 1 1 0 0 0]);
end
    
if isfield(source,'df0')
    df0=source.df0;
else
    df0=0;
end

if isfield(source,'ddf0')
    ddf0=source.ddf0;
else
    ddf0=0;
end
f0=source.f0;

fr=(f0-df0*(t-t00)+ddf0*(t-t00).^2/2).*dop;

fr=gd(fr);
fr=edit_gd(fr,'x',t,'capt','Frequency shift');