function [p gout res]=show_polyfit(gin,n,range)
% show_polyfit  shows polynomial fit done by gd_polyfit
%
%   n       order of the polynomial
%           =-1  exponential case: computes the tau and initial amplitude
%   range   [min max] of the abscissa (def no selection)

% Version 2.0 - April 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

p=gd_polyfit(gin,n,range);
subgin=sel_gd(gin,0,0,range);

y=y_gd(gin);
x=x_gd(gin);
T=max(x)-min(gin);
ini=min(x);

n1=199;
x1=ini+(0:n1)*T/n1;

if n >= 0
    gout=polyval(p,x1);
else
    gout=p(2)*exp(-x1/p(1));
end
gout=gd(gout);
gout=edit_gd(gout,'dx',T/n1,'ini',ini);

if n >= 0
    res=y-polyval(p,x);
else
    res=y-p(2)*exp(-x/p(1));
end
res=edit_gd(gin,'y',res);

figure,plot(gin),hold on,grid on,plot(subgin,'r'),plot(gout,'g:'),title('Data with fit (red selected)')

figure,plot(res),title('Residuals')