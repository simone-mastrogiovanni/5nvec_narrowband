function cc=circ_cross(in1,in2)
% circular correlation
%
%   in1,in2  arrays or gds of the same length (and sampl)

% Version 2.0 - July 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dx=0;
if isa(in1,'gd')
    dx=dx_gd(in1);
    in1=y_gd(in1);
    in2=y_gd(in2);
end

in1=fft(in1);
in2=fft(in2);

cc=ifft(in1.*conj(in2));

if dx > 0
    cc=gd(cc);
    cc=edit_gd(cc,'dx',dx);
end