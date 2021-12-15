function p=gd_polyfit(gin,n,range)
% gd_polyfit  polynomial fit of a gd
%
%   n       order of the polynomial
%           =-1  exponential case: computes the tau and initial amplitude
%   range   [min max] of the abscissa (def no selection)

% Version 2.0 - April 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if exist('range','var')
    gin=sel_gd(gin,0,0,range);
end

x=x_gd(gin);
y=y_gd(gin);

if n >= 0
    p=polyfit(x,y,n);
else
    p=polyfit(x,log(y),-n);
    p(1)=-1/p(1);
    p(2)=exp(p(2));
end