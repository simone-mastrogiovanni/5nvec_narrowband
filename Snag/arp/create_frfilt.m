function frfilt=create_frfilt(basic_frfilt)
%CREATE_FRFILT  starting from a basic frequency filter, creates an operative
%               frequency filter, nullifying the central part of the fft
%               (the length of basic_frfilt should be divisible by 4)

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ff=fft(basic_frfilt);

n=length(basic_frfilt);
n4=n/4;

ff(n4:3*n4+2)=0;
a=(1-cos(pi/4))/2;
ff(n4-1)=ff(n4-1)*a;
ff(3*n4+3)=ff(3*n4+3)*a;
ff(n4-2)=ff(n4-2)*0.5;
ff(3*n4+4)=ff(3*n4+4)*0.5;
ff(n4-3)=ff(n4-3)*(1-a);
ff(3*n4+5)=ff(3*n4+5)*(1-a);

frfilt=ifft(ff);