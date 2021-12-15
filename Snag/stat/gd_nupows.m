function s=gd_nupows(g,frmin,res,nfr,meth)
%GD_NUPOWS  non-uniformly sampled data spectral estimation
%
%  g       data gd (typically type2)
%  frmin   start frequency
%  res     resolution (1, the minimum, is the "natural" = 1/(T_n-T_1))
%  nfr     number of frequencies
%  meth    method (1 simple, 2 subtract window,.., negative no plot)

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icpl=1;
if meth < 0
    meth=-meth;
    icpl=0;
end

y=y_gd(g);
t=x_gd(g);
N=n_gd(g);

tmin=min(t);
tmax=max(t);
tobs=(tmax-tmin);
dfr=1/(res*tobs);

om=2*pi*(frmin+(0:nfr-1)*dfr);

for i = 1:nfr
    s(i)=(abs(sum(y.*exp(-j*t*om(i)))).^2)/N;
end

if icpl > 0
    figure
    plot(om/(2*pi),s);
    grid on
end

s=gd(s);
s=edit_gd(s,'ini',frmin,'dx',dfr,'capt','non-uniform sampled data spectrum');
    