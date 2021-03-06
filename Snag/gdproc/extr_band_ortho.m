function [out,pars]=extr_band_ortho(in,band)
% extract band (output signal is complex)
%    out=extr_band(in,band,st)
%
%   in    input gd (type 1)
%   band  [min  max] frequency
%   st    sampling time (if present; otherwise st=1/band)

% Snag Version 2.0 - June 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - UniversitÓ "Sapienza" - Rome

dt=dx_gd(in);
n=n_gd(in);
dfr=1/(dt*n);

pars.dt=dt;
pars.n=n;
pars.dfr=dfr;

bandw=band(2)-band(1);
st=1/bandw;
pars.bandw=bandw;

i1=floor(band(1)/dfr)+1;
i2=floor(band(2)/dfr);

pars.i1=i1;
pars.i2=i2;

ii=round(1/(st*dfr));

pars.st=st;

y=y_gd(in);
y=fft(y);
y=y(i1:i2);
y(i2-i1+1:ii)=0;
reduce=(i2-i1)/n;
y=ifft(y)*reduce;
out=edit_gd(in,'dx',st,'y',y);