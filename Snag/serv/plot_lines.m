function plot_lines(xs,y,col)
% plots vertical lines on graphs
%
%    xs   (1,n) (or (2,n)) abscissas (and ordinate) of lines
%    y    ordinate of data or gd
%    col  color/style (default 'g')

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('col','var')
    col='g';
end

if ~isnumeric(y)
    y=y_gd(y);
end

xs=xs(:)';
[ic,n]=size(xs);

mi=min(y);
ma=max(y);
hold on

for i = 1:length(xs)
    if ic == 2
        ma=xs(2,i);
    end
    plot([xs(1,i),xs(1,i)],[mi,ma],col);
end