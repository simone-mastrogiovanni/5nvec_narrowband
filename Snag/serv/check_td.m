function td=check_td(sp,icsqrt)
%CHECK_TD  checks the time domain
%
%   sp         fr domain data (gd or array)
%   icsqrt     = 1  -> operates on the sqrt

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% bySergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(sp,'gd')
    sp=y_gd(sp);
end

if icsqrt == 1
    sp=sqrt(sp);
end

td=ifft(sp);

%snag_plot(1:length(td),real(td));
figure
plot(real(td)),grid on, zoom on