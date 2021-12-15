function [out,extr_pars]=bsd_subband_ortho(in,tab,band)
% extract band (output signal is complex)
%  [similar to extr_band]
%
%    [out,extr_pars]=bsd_subband(in,tab,band,st)
%
%   in    input gd (type 1)
%   tab   table with the sub-set of bsd or []
%   band  [min  max] frequency (aliased or not)
%   st    sampling time (if present; otherwise st=1/band)
%         if absent, uses bsd_reshape
%
% ATTENTION ! the samples start since the 0 hour of the first day of the run
%             so, the first sample of the file can be advanced: in this
%             case the first sample is a 0.

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=ccont_gd(in);

oper=struct();
oper.op='bsd_subband';
if isfield(cont,'oper')
    oper.oper=cont.oper;
end
oper.tab=tab;
oper.band=band;
st=1/(band(2)-band(1));
oper.st=st;

cont.oper=oper;

inifr0=cont.inifr;
if band(1) >= cont.inifr
    band=band-inifr0;
end

[out,extr_pars]=extr_band_ortho(in,band); extr_pars

dfr=extr_pars.dfr;
inifr=cont.inifr+floor(band(1)/dfr)*dfr;
cont.inifr=inifr;
% cont.inifr=cont.inifr+extr_pars.inifr+extr_pars.dfr;
cont.bandw=extr_pars.bandw;
cont.sb_pars=extr_pars;

out=edit_gd(out,'cont',cont);

out=bsd_zeroholes(out,in);