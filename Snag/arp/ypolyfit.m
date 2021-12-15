function y=ypolyfit(xx,yy,n)
% polynomial fit values
%
%     y=ypolyfit(xx,yy,n)
%
%   xx,yy  original values
%   n      polynomial degree

% Version 2.0 - October 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

p=polyfit(xx,yy,n);
y=polyval(p,xx);