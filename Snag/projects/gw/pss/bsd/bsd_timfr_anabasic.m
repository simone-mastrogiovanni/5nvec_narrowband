function [tfstr,out]=bsd_timfr_anabasic(in,anabasic)
% basic time-frequency analysis for bsd files
%
%    [tfstr,out]=bsd_timfr_anabasic(in,anabasic)
%
%   in             input bsd
%   anabasic       analysis control structure
%        .thr      spectral peak threshold (default 2.5)
%
%   tfstr          analysis output structure
%   out           (if present) t-f enriched bsd

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=cont_gd(in);

if ~isfield(anabasic,'thr')
    anabasic.thr=2.5;
end

thr=anabasic.thr;

tfstr=bsd_peakmap(in,lfft,thr,'median');


tfstr=bsd_tfclean(tfstr,anabasic);

if nargout == 2
    out=edit_gd(in,'tfstr',tfstr);
end