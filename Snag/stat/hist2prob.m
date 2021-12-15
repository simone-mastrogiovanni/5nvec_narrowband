function [p,dx,n]=hist2prob(hh,xh,pmod,ipl)
% probability function from histogram
%
%   hh     histogram
%   xh     hist abscissa (uniform) 
%   pmod   1 pdf, 2 cdf, 3 icdf
%   ipl    plot 0 no (def), 1 plot, 2 semilogx, 3 semilogy, 4 loglog

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('ipl','var')
    ipl=0;
end

n=sum(hh);
dx=xh(2)-xh(1);

p=hh/(n*dx);

switch pmod
    case 2
        p=cumsum(p)*dx;
    case 3
        p=cumsum(p,'reverse')*dx;
end

switch ipl
    case 1
        plot(xh,p),grid on
    case 2
        semilogx(xh,p),grid on
    case 3
        semilogy(xh,p),grid on
    case 4
        loglog(xh,p),grid on
end