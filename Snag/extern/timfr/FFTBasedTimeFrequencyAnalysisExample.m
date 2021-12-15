%% FFT-Based Time-Frequency Analysis
% The Signal Processing Toolbox(TM) product provides a function,
% |spectrogram|, that returns the time-dependent Fourier transform for a
% sequence, or displays this information as a spectrogram. The
% _time-dependent Fourier transform_ is the discrete-time Fourier transform
% for a sequence, computed using a sliding window. This form of the Fourier
% transform, also known as the short-time Fourier transform (STFT), has
% numerous applications in speech, sonar, and radar processing. The
% _spectrogram_ of a sequence is the magnitude of the time-dependent
% Fourier transform versus time.

% Copyright 2015 The MathWorks, Inc.


%%
% To display the spectrogram of a linear FM signal:

fs = 10000;
t = 0:1/fs:2;
x = vco(sawtooth(2*pi*t,0.75),[0.1 0.4]*fs,fs);
spectrogram(x,kaiser(256,5),220,512,fs,'yaxis')