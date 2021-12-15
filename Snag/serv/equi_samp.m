function i2=equi_samp(y1,y2,i1,red)
% equivalente sample in 2 vectors (for coincidences)
%
%   iout=equi_samp(y1,y2,iin)
%
%   y1,y2   2 vectors (monotonic)
%   i1      sample(s) of y1
%   red     reduction parameter (def 1000)
%
%   i2      equivalent y2 sample (out of range data are put extremal)

% Snag Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('red','var')
    red=1000;
end

n1=length(y1);
mi1=y1(1);
ma1=y1(n1);

n2=length(y2);
mi2=y2(1);
ma2=y2(n2);

ii1=find(y1(i1) < mi2);
ii2=find(y1(i1) > ma2);
ii=find(y1(i1) >= mi2 & y1(i1) <= ma2);

j=[1:red:n2-1 n2];
IY2=spline(y2(j),j,y1(i1));

i2=i1*0;
i2(ii1)=1;
i2(ii2)=n2;
i2(ii)=IY2(ii);
i2=round(i2);