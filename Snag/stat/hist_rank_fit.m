function [g,pars]=hist_rank_fit(h,xh,ro)
% rank fit for (uniform) histograms
%
%   h    histogram (or part of)
%   xh   hist abscissas
%   ro   rank order (e.g. number of antennas)

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

pars=dist_pars(xh,h);
dof=2*ro;

g=chi2pdf(xh*dof/pars.mu,dof)*dof*pars.N;

figure,semilogy(xh,h),hold on,semilogy(xh,g,'g')

ii=find(h > 0);
ylim([min(h(ii)),1.2*max(h)]);
grid on

edof=2*pars.mu^2/pars.cmom(2);
pars.estdof=round(edof);
pars.errdof=edof-round(edof);
