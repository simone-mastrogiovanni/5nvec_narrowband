function pint=integralF_fromhist(h)
% reversed cumulative distribution from histogram
%
%   pint=integralF_fromhist(h)
%
%   h   input histogram (array or gd)

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

icgd=0;
if isa(h,'gd')
    h1=h;
    icgd=1;
    h=y_gd(h);
end
s=sum(h);
n=length(h);

pint(n:-1:1)=cumsum(h(n:-1:1))/s;

if icgd == 1
    pint=edit_gd(h1,'y',pint);
end