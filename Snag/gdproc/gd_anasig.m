function out=gd_anasig(in)
%GD_ANASIG  creates the analytic signal (Hilbert transform)
%

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

igd=0;
if isobject(in)
    igd=1;
    out1=in;
    capt=[capt_gd(in) ' analytic'];
    in=y_gd(in);
end

n=length(in);
n2=floor(n/2);
n3=n-n2+2;
out=fft(in);

out(2:n2)=2*out(2:n2);
out(n3:n)=0;
out(n2+1:n3)=0;

out=ifft(out);

if igd == 1
    out=edit_gd(out1,'y',out,'capt',capt)
end