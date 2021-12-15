function [out,pars]=extr_band(in,band,st)
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
% subsampfact=dt*bandw;

i1=floor(band(1)/dfr)+1;
i2=floor(band(2)/dfr);

pars.i1=i1;
pars.i2=i2;

% pars.inifr=(i1-1)*dfr;
pars.inifr=i1*dfr;
pars.bandw=(i2-i1+1)*dfr;

if exist('st','var')
    if pars.bandw > 1/st
        st1=1/pars.bandw;
        fprintf('Requested s.t. %f too high: new s.t. %f\n',st,st1)
        st=st1;
    end
else
    st=1/pars.bandw;
end
st0=st;
ii=round(1/(st*dfr));
st=1/(ii*dfr);

pars.st0=st0;
pars.st=st;

y=y_gd(in);
y=fft(y);
y=y(i1:i2);
y(i2-i1+1:ii)=0;
reduce=(i2-i1)/n;
y=ifft(y)*reduce;
out=edit_gd(in,'dx',st,'y',y);