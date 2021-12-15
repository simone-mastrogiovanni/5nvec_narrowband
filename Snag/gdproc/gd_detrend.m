function out=gd_detrend(in,ord)
% correct bias and trend
%
%    out=gd_detrend(in,ord)
%
%   in   input gd or array
%   ord  order of correction (0 only bias)

% Snag Version 2.0 - January 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

icgd=0;
if ~isnumeric(in)
    icgd=1;
    in1=in;
    in=y_gd(in);
end
n=length(in);

icreal=0;
if isreal(in)
    icreal=1;
end

x=-round(n/2):-round(n/2)+n-1;
p=polyfit(x,in,ord);
out=in-polyval(p,x);

if icgd == 1
    out=edit_gd(in1,'y',out);
end