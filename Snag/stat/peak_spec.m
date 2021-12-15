function sp=peak_spec(g,minfr,maxfr,res)
% PEAK_SPEC  peak spectrum
%
%    sp=peak_spec(g,minfr,maxfr,res)
%
%   g      a type-2 gd with data
%   minfr  min frequency (if minfr > manfr periods are intended)
%   maxfr  max frequency
%   res    resolution (1 = natural)

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[y n dt ini capt t]=extr_gd(g);

icper=0;
if minfr > maxfr
    icper=1;
    minfr=1/minfr;
    maxfr=1/maxfr;
end
    
DT=max(t)-min(t);
dfr=1/(DT*res);
fr=minfr;
nfr=0;
sp=zeros(1,1000);

while fr <= maxfr
    om=fr*2*pi;
    nfr=nfr+1;
    if floor(nfr/1000)*1000 == nfr-1
        sp(nfr:nfr+999)=zeros(1,1000);
    end
    sp(nfr)=abs(sum(y.*exp(j*om*t)));
    fr=fr+dfr;
end

sp=sp(1:nfr);
sp=sp.*sp/n;
sp=gd(sp);
sp=edit_gd(sp,'ini',minfr,'dx',dfr,'capt','peak spectrum');

if icper > 0
    x=1./x_gd(sp);
    sp=edit_gd(sp,'ini',1/maxfr,'x',x,'capt','peak spectrum');
end
    