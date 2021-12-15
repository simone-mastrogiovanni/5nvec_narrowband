function matfrfilt=create_matfrfilt(shape,delay,lenout)
%CREATE_MATFRFILT  creates the frequency domain matched to a given shape
%
%     shape   the waveform to be matched
%     delay   the delay to have 0 delay (in samples)
%     lenout  the length of the output filter
%
% If the noise is not white, this filter, matched to the original shape,
% should be applied after the wiener filter

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

lsh=length(shape);
if lsh > lenout
    disp('shape too long')
    return
end

shape(lsh+1:lenout)=0;
shape=rota(shape,-delay);
n=lenout;

ff=fft(shape);
ff=conj(ff);

n4=n/4;

ff(n4:3*n4+2)=0;
a=(1-cos(pi/4))/2;
ff(n4-1)=ff(n4-1)*a;
ff(3*n4+3)=ff(3*n4+3)*a;
ff(n4-2)=ff(n4-2)*0.5;
ff(3*n4+4)=ff(3*n4+4)*0.5;
ff(n4-3)=ff(n4-3)*(1-a);
ff(3*n4+5)=ff(3*n4+5)*(1-a);

matfrfilt=ifft(ff);