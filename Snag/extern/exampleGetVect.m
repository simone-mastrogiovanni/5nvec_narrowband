%---- define file name and channel name
% 
 file = '../data/test.dat';
 channel = 'fastAdc1';
%
% ---first get data from frames -------------
%
 [a,t,f,t0,t0s,c,u] = frgetvect(file,channel,663724172.,4.);
 [a,t,f,t0,t0s,c,u] = frgetvect(file,channel,0.,4.);
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
 loglog(f,m)
 ylabel('power')
 xlabel('frequency [Hz]')
 title(['FFT for ',channel])
