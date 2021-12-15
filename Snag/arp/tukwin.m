function win=tukwin(N,perc)
% TUKWIN  Tukey window
%
%    win=tukwin(N,perc)
%
%   N      length
%   perc   percentage (0 -> 0.5)

% Version 2.0 - June 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

win=ones(1,N);
n1=round(perc*N);
x=(1-cos((1:n1)*pi/n1))/2;

win(2:n1+1)=x;
win(N:-1:N-n1+1)=x;
win=win/sqrt(mean(win.^2));
win(1)=0;