function out=ps_autoequalize(in,nsm,ch)
%PS_AUTOEQUALIZE  power spectrum equalizer
%
%    in      input power spectrum
%    nsm     smoothing factor
%    ch      1 if in input are full spectra 
%    out     equalized ps

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(in);

if ch == 1
    n2=n/2;
else
    n2=n;
    in(n2+1)=0;
    in(2*n2:-1:n2+2)=in(2:n2);
end

ns=ceil(n2*2/nsm);

out=ifft(in);

out(1:ns)=out(1:ns).*(ns:-1:1)/ns;

out(ns+1:n2+1)=0;

% nwind=max(10,ceil(ns/512));
% 
% for i = 1:nwind
%     out(ns-i+1)=out(ns-i+1)*i/nwind;
% end

%out(1:n2)=out(1:n2).*(n2:-1:1)/n2;

out(2*n2:-1:n2+2)=out(2:n2);

out=fft(out);

out=real(in(1:n)./out(1:n));