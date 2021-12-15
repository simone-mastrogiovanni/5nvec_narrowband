function y=easy_smooth(x,n)
% EASY_SMOOTH  data smoothing
%
%   x    input data
%   n    smoothing depth (positive integer)
%
%   y    smoothed data

% Project LabMec - part of the toolbox Snag - April 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('n','var')
    n=1;
end

n=round(n);
if n < 1
    n=1;
end

win=1:n+1;
win(2*n+1:-1:n+2)=1:n;

y=conv(x,win)/(n+1)^2;
y=y(n+1:length(y)-n);