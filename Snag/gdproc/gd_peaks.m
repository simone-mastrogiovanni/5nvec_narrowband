function peaks=gd_peaks(gin,thresh)
%GD_PEAKS  finds peaks
%
%    gin      input gd
%    thresh   threshold

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

y=y_gd(gin);
x=x_gd(gin);
y=y(:);

y1=rota(y,1);
y2=rota(y,-1);
y1=ceil(sign(y-y1)/2);
y2=ceil(sign(y-y2)/2);
y1=y1.*y2;
y=y.*y1;
y2=ceil(sign(y-thresh)/2);
y=y.*y2;
npeak=sum(y2)
[i1,j1,s1]=find(y);

peaks=gd(s1);
peaks=edit_gd(peaks,'type',2,'x',x(i1),'capt',['peaks of ' capt_gd(gin)]);