function out=fft_oversamp(in,fact,vig)
%FFT_OVERSAMP  oversampling for fft data
%
%     in      input vector (full fft or ps; should have even length)
%     fact    oversampling factor
%     vig     vignetting (e.g. 10)
%
%     out     output vector

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(in);
n2=n/2;
nn2=round(n2*fact);
isr=isreal(in);
    

out=zeros(1,2*nn2);

in=fft(in);
out(1:n2)=in(1:n2);
out(2*nn2-n2+2:2*nn2)=in(n2+2:n);

for i = 1:vig
    out(n2-i+1)=out(n2-i+1)*i/vig;
    out(2*nn2-n2+i+1)=out(2*nn2-n2+i+1)*i/vig;
end

out=ifft(out)*fact;
if isr
    out=real(out);
end

