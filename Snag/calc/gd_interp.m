function out=gd_interp(gin,Xin)
% interpolation of a gd
%
%   out=gd_interp(gin,Xin)

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

x=x_gd(gin);
y=y_gd(gin);
n=n_gd(gin);

[x,ix]=sort(x);
y=y(ix);

minx=min(x)-(x(2)-x(1))/2;
maxx=max(x)+(x(n)-x(n-1))/2;

ii=find(Xin < minx);
Xin(ii)=minx;
ii=find(Xin > maxx);
Xin(ii)=maxx;

out=spline(x,y,Xin);