function [s eq_nois]=pss_ns_sens(sens,hough_thresh,tfftfix)
% PSS_NS_SENS  non-stationary ideal sensitivity
%               (for Adaptive Hough Procedure)
%
%            s=pss_ns_sens(sens)
%
%    sens           sensitivity structure array
%        .h         h noise frequency density
%        .tobs      observation time for that noise (in days)
%    hough_thresh   Hough threshold (default 3.8)
%    tfftfix        fixed Tfft (0 or absent -> "optimal")
%
%    s              pss sensitivity
%    eq_nois        equivalent stationary noise
%
%  all h should be "parallel" gds (same ini, same dx): use parall_gd if needed

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('hough_thresh','var')
    hough_thresh=3.8;
end

n=length(sens)

tobs=sens(1).tobs;
fr=x_gd(sens(1).h);
c=299792458;
R0Om02=0.024781;
tfft=sqrt(c./(2*fr*R0Om02));
if exist('tfftfix','var')
    if tfftfix > 0
        tfft=tfftfix;
    end
end

N=round(86400*tobs./tfft);
y=N./y_gd(sens(1).h).^4;
y1=tobs./y_gd(sens(1).h).^4;
TOBS=tobs;

for i = 2:n
    tobs=sens(i).tobs;
    N=round(86400*tobs./tfft);
    y=y+N./y_gd(sens(i).h).^4;
    y1=y1+tobs./y_gd(sens(i).h).^4;
    TOBS=TOBS+tobs;
end

y=tfft.*sqrt(y);
y=3.78*sqrt(hough_thresh/3.8)./sqrt(y);
y1=1./(y1./TOBS).^0.25;

s=sens(1).h;
s=edit_gd(s,'y',y,'capt','pss sensitivity');

eq_nois=s;
eq_nois=edit_gd(eq_nois,'y',y1,'capt','equivalent noise');