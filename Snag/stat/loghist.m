function [h, edg]=loghist(x,par,slog,vlog)
% histogram & C
%
%    [h edg]=loghist(x,par,slog,vlog)
%
%   x     data
%   par   [min,max,N] hist interval and number of bins or edges (>3)
%   slog  = 0  linear x scale
%           1  log x scale
%   vlog  = 2 no plot
%           0 linear vertical scale
%           1 log vertical scale

% Snag Version 2.0 - June 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if length(par) == 3
    if slog == 0
        dx=(par(2)-par(1))/par(3);
        edg=par(1)+dx*(0:par(3));
    else
        dx=(par(2)/par(1)).^(1/par(3));
        edg=par(1)*dx.^(0:par(3));
    end
else
    edg=par;
    par(1)=edg(1);
    par(2)=edg(length(edg));
    par(3)=length(edg)-1;
end

h=histcounts(x,edg);

if vlog < 2
    stairs(edg,[h h(par(3))]);
    grid on
    if slog == 1
        set(gca, 'XScale', 'log')
    end
end
if vlog == 1
    set(gca, 'YScale', 'log')
end
