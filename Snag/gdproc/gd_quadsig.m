function out=gd_quadsig(in)
%GD_QUADSIG  creates the quadrature signal (Hilbert transform)
%

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

igd=0;
if isobject(in)
    igd=1;
    out1=in;
    capt=[capt_gd(in) ' quad'];
    in=y_gd(in);
end

icmpl=1
if isreal(in)
    icmpl=0;
end

n=length(in);
n2=floor(n/2);
n3=n-n2+2;
out=fft(in);

out(1)=0;
out(2:n2)=j*out(2:n2);
out(n3:n)=-j*out(n3:n);
out(n2+1:n3)=0;

out=ifft(out);

if icmpl == 0
    out=real(out);
end

if igd == 1
    out=edit_gd(out1,'y',out,'capt',capt)
end