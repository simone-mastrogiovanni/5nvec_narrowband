function out=bsd_specfilt(in,sourd,res)
% applies spectral filter to a bsd
%
%   out=bsd_specfilt(in,sour,res)
%
%   in     input bsd
%   sourd  source declination (deg) or source
%   res    resolution

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=ccont_gd(in);
eval(['ant=' cont.ant ';'])
if isstruct(sourd)
    sour=sourd;
else
    sour=per_sour(100,[0 sourd],[0 0]);
end

spfilt=crea_spec_filter(sour,ant);

out=spec_filter(in,sour,ant,res);
