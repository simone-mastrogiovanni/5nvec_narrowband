function g1=type2_2_1(g2)
% TYPE2_2_1 approximates a type2 gd with a type1 gd
%           the g2 should be sorted 

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

x=g2.x;
difx=diff(x);
i1=find(difx<mean(difx));
dx=mean(difx(i1))
n=g2.n;

Dx=max(x)-min(x)
nn=round(Dx/dx)+1;

difx=diff(x);

x1=x(1)+(0:round(Dx/dx))*dx;

g1=spline(x,cumsum(g2.y),x1);
g1=[g1(1) diff(g1)];

g1=gd(g1);
g1.dx=dx;
g1.ini=x(1);
g1.capt=[g2.capt ' -> type 1 gd'];