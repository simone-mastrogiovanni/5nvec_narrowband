function A=hist_2D(XY,x,y)
% 2D histogram 
%
%    A=hist_2D(XY,x,y)
%
%  XY   (n,2) data
%  x    x grid  (or number of bins)
%  y    y grid (must be uniform)   (or number of bins)

% Version 2.0 - May 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if length(x) == 1
    xmin=min(XY(:,1));
    xmax=max(XY(:,1));
    dx=(xmax-xmin)/(x-1);
    x=xmin:dx:xmax;
end

if length(y) == 1
    ymin=min(XY(:,2));
    ymax=max(XY(:,2));
    dy=(ymax-ymin)/(y-1);
    y=ymin:dy:ymax;
end

ctrs{1}=x;
ctrs{2}=y;

A=hist3(XY,ctrs);

A=gd2(A);
A=edit_gd2(A,'x',x,'ini2',y(1),'dx2',y(2)-y(1),'capt','hist_2D');