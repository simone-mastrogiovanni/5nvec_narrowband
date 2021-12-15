function out=ps_equalize(in,sps,ch)
%PS_EQUALIZE  power spectrum equalizer
%
%    in    input power spectrum
%    sps   short power spectrum
%    ch    1 if in input are full spectra 
%    out   equalized ps

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(in);
ns=length(sps);

if ch == 1
    n2=n/2;
    ns=ns/2;
else
    n2=n;
    sps(2*ns:-1:ns+2)=sps(2:ns);
    sps(ns+1)=0;
end

sps=ifft(sps);
out(1:ns)=sps(1:ns);
out(ns+1:n2+1)=0;

nwind=max(10,ceil(ns/512));

for i = 1:nwind
    out(ns-i+1)=out(ns-i+1)*i/nwind;
end

%out(1:n2)=out(1:n2).*(n2:-1:1)/n2;

out(2*n2:-1:n2+2)=out(2:n2);
out=fft(out)*n2/ns;

out=real(in./out(1:n));