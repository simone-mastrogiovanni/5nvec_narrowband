function out=full_peak_spec(tim,amp,par)
% some spectral analysis on event or peak data
%
%     out=full_peak_spec(tim,amp,par)
%
%   tim   event ot peak times
%   amp   amplitude
%   par   parameters
%
%   Analysis:
%
%   peak_spec        peak spectrum
%   gd_nud_spec      spectrum for non-uniformly sampled data
%   gd_period        analysis for the presence of a periodicities with folding
%   epfol_plotnfit   epfol_plotnfit plot and fit for epoch folding
%   ls_periodogram   Lomb-Scargle periodogram
%   lombscargle      driver for lomb function (Dmitry Savransky)
%   gd_nupows        non-uniformly sampled data spectral estimation
%   tfr_pspec        time-frequency pulse power spectrum

g1=gd(amp);
g1=edit_gd(g1,'x',tim);

if ~exist('par','var')
    par=struct();
end

if ~isfield(par,'spec')
    par.spec.fr=[0 4.1 6];  % minfr, maxfr, res
end

minfr=par.spec.fr(1);
maxfr=par.spec.fr(2);
res=par.spec.fr(3);

out.sp=peak_spec(g1,minfr,maxfr,res);
[out.sp1 out.sp4 out.spall out.ft]=gd_nud_spec(g1,[minfr maxfr],res,12);
out.pls=ls_periodogram(tim,amp,[minfr maxfr res]);

[out.periodsid out.harmsid out.percleansid out.winsid]=gd_period(g1,'sid',48,4,0);
[out.periodsol out.harmsol out.percleansol out.winsol]=gd_period(g1,'day',48,4,0);
