function sp2=spec_2l(sp1)
%SPEC_2L  redoubles the length of a spectrum inserting an hole in the time domain
%         of the sqrt
%
%       sp1    input spectrum (double or gd)

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icgd=0;

if isa(sp1,'gd')
    icgd=1;
    dx=dx_gd(sp1);
    capt=capt_gd(sp1);
    sp1=y_gd(sp1);
end

n=length(sp1);
a=ifft(sqrt(real(sp1)));
sp2=zeros(2*n,1);

sp2(1:n/2)=a(1:n/2);
sp2(3*n/2+1:2*n)=a(n/2+1:n);

sp2=fft(real(sp2));
sp2=real(sp2).^2;

if icgd == 1
    sp2=gd(sp2);
    sp2=edit_gd(sp2,'dx',dx/2,'capt',[capt ' - doubled spectrum']);
end