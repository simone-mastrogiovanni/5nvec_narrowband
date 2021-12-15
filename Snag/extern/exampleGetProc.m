%---- define file name and channel name
% 
 file = '../data/test.dat';
 channel = 'fastProc';
%
% ---first extract data from frames (sequential read) ---
%
 [a,t,f,t0,t0s,c,u,more] = frextract(file,channel,2,3);
%
 subplot(3,1,1)
 plot(t,a) 
 ylabel(channel)
 xlabel('time [s]')
     title(t0s)
%
%----- then do a random access to extract the same data --
%
 [a,t,f,t0,t0s,c,u] = frgetvect(file,channel,t0,3.);
%
 subplot(3,1,2)
 plot(t,a) 
 ylabel(channel)
 xlabel('time [s]')
 title(t0s)
%
%----- then do a random access to extract part of the data --
%
 [a,t,f,t0,t0s,c,u] = frgetvect(file,channel,t0+.6,0.6);
%
 subplot(3,1,3)
 plot(t,a) 
 ylabel(channel)
 xlabel('time [s]')
 title(t0s)
