function plot_nozero(x,y,no_band,com)
% PLOT_NOZERO  plots data excluding around zero band
%
%    plot_nozero(x,y,no_band,com)
%
%      x,y        original data
%      no_band    canceled band around zero
%      com        if present, comand string, as ''r'' 

% Version 2.0 - January 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('com','var')
    com='''b''';
end
i=find(abs(y) > no_band);
x=x(i);
y=y(i);
str=['plot(x,y,' com ')'];
eval(str)