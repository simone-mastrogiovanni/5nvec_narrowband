%---- define file name and channel name
% 
 file = '../data/test.dat';
 channel = 'fastAdc1';
%
% ---first extarct data from frames -------------
%
 [a,t,f,t0,t0s,c,u,more] = frextract(file, channel,2,5);
%
%---------- plot time serie --------------------
%
 subplot(2,1,1)
 plot(t,a) 
 ylabel(channel)
 xlabel('time [s]')
 title(t0s)
%
%------ compute and plot FFT --------------------
% 
 b = fft(a);
 m = abs(b(1:length(b)/2));
 subplot(2,1,2)
 semilogy(f,m)
 ylabel('power')
 xlabel('frequency [Hz]')
 title(['FFT for ',channel])
%
%---- write an audio file (listen it with Netscape) ----
%
 auwrite(a/max(abs(a)),16384.,'audio.au')
